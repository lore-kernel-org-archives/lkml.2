Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1IGBZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 21:25:39 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3829 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1IGBZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 21:25:34 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Date: Tue, 6 Sep 2011 18:25:15 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Florian Mickler" <florian@mickler.org>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Benjamin Li" <benli@broadcom.com>,
        "Michael Chan" <mchan@broadcom.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Francesco Piccinno" <stack.box@gmail.com>
Subject: Re: re add support for bcm5750
Message-ID: <20110907012515.GA9038@mcarlson.broadcom.com>
References: <1280784368-4226-8-git-send-email-mcarlson@broadcom.com>
 <20110906170343.09252578@schatten.dmk.lab>
MIME-Version: 1.0
In-Reply-To: <20110906170343.09252578@schatten.dmk.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-WSS-ID: 627816E25IS2840089-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 08:03:43AM -0700, Florian Mickler wrote:
> Hi,
> 
> in https://bugzilla.kernel.org/show_bug.cgi?id=42132 Francesco wrote: 
> 
> > I have a notebook (HP TC4400) which has a BCM5750 ethernet card inside. The
> > ouput of lspci is:
> > 
> > 08:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme BCM5750M
> > Gigabit Ethernet [14e4:167c]
> > 
> > Commit 67b284d476bcb3d100e946da23d6cf9acfd0465c removed the support for this
> > device. I wish to have the support for this network card back again. Thanks!

Hi Florian.  Are you experiencing the same problem?  We found that
Francesco's problem was that the firmware of his device was missing.  Do
you see :

eth0: No firmware running

messages?

