Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab1DEAy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 20:54:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab1DEAyZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 20:54:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110404150846.54034f1b.rdunlap@xenotime.net>
References: <20110404145803.8663081d.rdunlap@xenotime.net> <20110404150846.54034f1b.rdunlap@xenotime.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Apr 2011 17:54:04 -0700
Message-ID: <BANLkTikSbTgsH1zHm+mEu6C3R5dEsw2ogA@mail.gmail.com>
Subject: Re: [PATCH 7/8] Documentation: consolidate leds files to leds/ subdir
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Antonio Ospite <ospite@studenti.unina.it>,
        akpm <akpm@linux-foundation.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 3:08 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>
> Changes since v1:
>  - don't use git renames

Actually, I think it would make it much easier to validate the patches
if you used git rename patches for things like this.

As a traditional patch, it's impossible to see that "yes, it's a
rename". There might be tons of changes hiding in the add/remove pair.

                          Linus
