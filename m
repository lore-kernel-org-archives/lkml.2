Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2CHCmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:42:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35660 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2CHCmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:42:49 -0500
Date: Wed, 7 Mar 2012 18:42:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 00/11] staging: Android updates (take 2)
Message-ID: <20120308024245.GB25842@kroah.com>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 05:34:27PM -0800, John Stultz wrote:
> Hi Greg, 
> 	Once again, here's the Android updates to the staging-next tree
> so they can be queued for 3.4. This time w/ commit style changes you
> requested I've pulled these from the common/android-3.3 branch, and made
> only some minor changes to keep everything in the staging dir and to avoid
> compile issues on x86.

I took the first 4, as I explain in the 5th patch, I can't take that
one, given that you are recreating existing apis we already have.

thanks,

greg k-h
