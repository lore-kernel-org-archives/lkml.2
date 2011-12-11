Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab1LKWPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 17:15:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60044 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1LKWPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 17:15:40 -0500
MIME-Version: 1.0
In-Reply-To: <1323641436-12249-1-git-send-email-brgerst@gmail.com>
References: <CAMzpN2jiZn3=Og9EVhnWbEhZkvi6eebEJpR7qYn00OyJnZgcFQ@mail.gmail.com>
	<1323641436-12249-1-git-send-email-brgerst@gmail.com>
Date: Sun, 11 Dec 2011 17:15:39 -0500
Message-ID: <CAMzpN2izpSgT1D4XQ_unkg4dvZCuTioPx1n98mrui50Ta+txMQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Split off mem*io functions
From: Brian Gerst <brgerst@gmail.com>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, torvalds@linux-foundation.org,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 5:10 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Commit 6175ddf06b6172046a329e3abfd9c901a43efd2e changed the mem*io
> functions to use the standard memcpy/memset routines, but there were
> unintended consequences.  Some devices cannot cope with 64-bit or
> non-sequential accesses that the optimized routines do.  Change them
> back to simple 32-bit sequential writes.

Tim, please test the lx6464es driver with this patch and commit
a2987855 reverted.

--
Brian Gerst
