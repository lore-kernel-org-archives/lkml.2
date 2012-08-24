Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2HXWfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:35:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2HXWfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:35:05 -0400
Date: Fri, 24 Aug 2012 15:35:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: GShark Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] backlight: Add Backlight driver for lm3630 chip
Message-Id: <20120824153503.bddefa10.akpm@linux-foundation.org>
In-Reply-To: <CAPqQCJUzVmDj9HESrqaVo1jKGXw5BjxQt_06p7+7mxG2_Wyxfw@mail.gmail.com>
References: <1344832471-13568-1-git-send-email-gshark.jeong@gmail.com>
	<1344832471-13568-2-git-send-email-gshark.jeong@gmail.com>
	<20120820133639.aa6db587.akpm@linux-foundation.org>
	<CAPqQCJX=kHo4kmQyZKgWq+z-ZVSP-7fv5MHsHBQo2bm-PDYp6w@mail.gmail.com>
	<CAPqQCJUzVmDj9HESrqaVo1jKGXw5BjxQt_06p7+7mxG2_Wyxfw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012 14:03:23 +0900
GShark Jeong <gshark.jeong@gmail.com> wrote:

> I've reviewed and tested you patch ( lm3630 and lm3639) on my real board
> and these are working well .
> Thank you.

Great, thanks.

> ( Do I need to  send back this patch to you again? or will the current
> status be applied for next branch? )

No, that's OK - when the time comes to send the patch upstream I shall
first fold the fixup patches into the base patch and update the changelog.
