Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2DWTrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 15:47:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2DWTq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 15:46:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks", take 3
Date: Mon, 23 Apr 2012 21:51:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201204222319.02228.rjw@sisk.pl> <20120423164940.GA10111@kroah.com>
In-Reply-To: <20120423164940.GA10111@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204232151.38654.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 23, 2012, Greg KH wrote:
> On Sun, Apr 22, 2012 at 11:19:01PM +0200, Rafael J. Wysocki wrote:
> > Hi all,
> > 
> > Following is the third update of the autosleep patchset.
> > 
> > Patches [1-4/8] are regarded as v3.5 material, the rest - depending on
> > the feedback I get (lack of feedback will be understood as no objections,
> > though).
> 
> This all looks great to me, thanks for continuing to push this:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks a lot!

Rafael
