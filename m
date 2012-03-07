Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316Ab2CGVwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:52:45 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44864 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab2CGVwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:52:43 -0500
Message-ID: <1331157153.2191.187.camel@work-vm>
Subject: Re: [GIT PULL] staging: Android updates
From: John Stultz <john.stultz@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Android Kernel Team <kernel-team@android.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Wed, 07 Mar 2012 13:52:33 -0800
In-Reply-To: <20120307214258.GA12190@kroah.com>
References: <1331156046.2191.185.camel@work-vm>
	 <20120307214258.GA12190@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-1976-0000-0000-00000B4480F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 13:42 -0800, Greg KH wrote:
> On Wed, Mar 07, 2012 at 01:34:06PM -0800, John Stultz wrote:
> > Hi Greg, 
> > 	Just wanted to send along some Android updates to the staging-next tree
> > so they can be queued for 3.4. I've pulled these from the
> > common/android-3.3 branch, and made only some minor changes to keep
> > everything in the staging dir and to avoid compile issues on x86.
> 
> Ick, I really don't like git pull requests for staging tree stuff at the
> moment.  Besides, you didn't sign your pull request, so I couldn't take
> it anyway :)
> 
> Can you just send these in email using 'git send-email' instead?  That
> works with my workflow very easily.

Sure. I can use git-send-email.

thanks
-john


