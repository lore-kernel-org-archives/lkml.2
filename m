Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1IGShU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:37:20 -0400
Received: from ist.d-labs.de ([213.239.218.44]:46284 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1IGShS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:37:18 -0400
Date: Wed, 7 Sep 2011 20:36:46 +0200
From: Florian Mickler <florian@mickler.org>
To: "Matt Carlson" <mcarlson@broadcom.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Benjamin Li" <benli@broadcom.com>,
        "Michael Chan" <mchan@broadcom.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Francesco Piccinno" <stack.box@gmail.com>
Subject: Re: re add support for bcm5750
Message-ID: <20110907203646.2a7b7833@schatten.dmk.lab>
In-Reply-To: <20110907012515.GA9038@mcarlson.broadcom.com>
References: <1280784368-4226-8-git-send-email-mcarlson@broadcom.com>
	<20110906170343.09252578@schatten.dmk.lab>
	<20110907012515.GA9038@mcarlson.broadcom.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011 18:25:15 -0700
"Matt Carlson" <mcarlson@broadcom.com> wrote:

> On Tue, Sep 06, 2011 at 08:03:43AM -0700, Florian Mickler wrote:
> > Hi,
> > 
> > in https://bugzilla.kernel.org/show_bug.cgi?id=42132 Francesco wrote: 
> > 
> > > I have a notebook (HP TC4400) which has a BCM5750 ethernet card inside. The
> > > ouput of lspci is:
> > > 
> > > 08:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme BCM5750M
> > > Gigabit Ethernet [14e4:167c]
> > > 
> > > Commit 67b284d476bcb3d100e946da23d6cf9acfd0465c removed the support for this
> > > device. I wish to have the support for this network card back again. Thanks!
> 
> Hi Florian.  Are you experiencing the same problem?  We found that
> Francesco's problem was that the firmware of his device was missing.  Do
> you see :
> 
> eth0: No firmware running
> 
> messages?
> 

Hi Matt!
No, I was just browsing the regression list and found this entry but
couldn't associate any action with it. 

This clears that up, thanks for the information and I will close this
bug. 

Regards,
Flo
