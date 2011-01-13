Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1AMP4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:56:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757208Ab1AMP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:56:08 -0500
MIME-Version: 1.0
In-Reply-To: <1294916869-2417-1-git-send-email-chris@chris-wilson.co.uk>
References: <AANLkTinBnm+xkXPPM4-3PG_i2hJMuXhv8x42KN4o3kGg@mail.gmail.com> <1294916869-2417-1-git-send-email-chris@chris-wilson.co.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jan 2011 07:54:59 -0800
Message-ID: <AANLkTimypim707rEXaPBaKoGgGmz3Of4EmPNw7VokJL6@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/execbuffer: Clear domains before beginning reloc processing
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 3:07 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> After reordering the sequence of relocating objects, commit 6fe4f1404,
> we can no longer rely on seeing all reloc targets prior to performing
> the relocation. So we need to clear the relocation domains earlier.

Yup, this one (together with the previous fix) seems to get rid of all
the artifacts.

Should I just apply them as patches, or do you have a git branch to pull from?

                                  Linus
