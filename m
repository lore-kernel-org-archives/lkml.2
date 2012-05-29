Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2E2Q5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:57:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36512 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab2E2Q5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:57:22 -0400
Date: Wed, 30 May 2012 01:57:04 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/91] 3.4.1-stable review
Message-ID: <20120529165704.GA25721@kroah.com>
References: <20120527010903.GA18244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120527010903.GA18244@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 10:09:03AM +0900, Greg KH wrote:
> Note, I've tested this release a bit differently than I have in the
> past.  For this release, I've only tested it on one machine, my laptop,
> with a pretty minimal configuration to save on build times.  That means,
> while this release works for me, it might not for you, and it might not
> even build at all for you.  Please test to verify that I haven't messed
> anything up.  I'll give everyone at least an extra day than "normal" for
> this review cycle before I cut a final 3.4.1 release.

It looks like people get even more time to test as I'm not going to be
able to push these updates out until Thursday or Friday at the earliest,
due to me being stuck in an area of Asia where the internet connectivity
really isn't all that good.

Sorry for the delay,

greg k-h
