Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1HDCM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 22:12:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62409 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab1HDCMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 22:12:23 -0400
Date: Thu, 04 Aug 2011 02:13:35 +0000
From: Ayan George <ayan@ayan.net>
To: psusi@cfl.rr.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: loop device auto release patch
Message-ID: <4e3a004f.w3IoBoSiMXE/VS4Z%ayan@ayan.net>
References: <4E1F3BE0.8040506@ayan.net> <4E209132.7000704@cfl.rr.com>
 <20110715121903.dc543613.akpm@linux-foundation.org>
 <4E39FCC0.4000800@cfl.rr.com>
In-Reply-To: <4E39FCC0.4000800@cfl.rr.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi <psusi@cfl.rr.com> wrote:
> On 07/15/2011 03:19 PM, Andrew Morton wrote:
> > The patch appears to do two unrelated things.  That's generally frowned
> > upon, but doesn't bother me much if the patch is small.
> > 
> > Still, splitting it into two patches (in which the bugfix is staged
> > first) would be advantageous for people who might wish to backport the
> > fix into earlier kernels.
>
> It looks like this got stalled and someone emailed me asking what
> happened to it.  I'm not sure that splitting the patch in two makes
> sense.  I don't see how it does two unrelated things. 

I agree -- I can't think of a meaningful way to split it up. I am
stalled in testing it however.

I watched the values of lo->lo_device and bdev using systemtap and
noticed cases where they could be out of sync which *might* make
this patch invalid.  I'd like a little more time to investigate.

-ayan

