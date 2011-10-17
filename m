Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1JQCYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 22:24:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:51583 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab1JQCYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 22:24:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,356,1315206000"; 
   d="scan'208";a="78697870"
Subject: Re: 3.1-rc9 wifi problem
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: werner <w.landgraf@ru.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "dave.taht@gmail.com" <dave.taht@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "arend@broadcom.com" <arend@broadcom.com>,
        "toralf.foerster@gmx.de" <toralf.foerster@gmx.de>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "larry.finger@gmail.com" <larry.finger@gmail.com>
In-Reply-To: <4E9B9018.1000002@lwfinger.net>
References: <web-626905859@zbackend1.aha.ru> <4E9A4496.1000906@lwfinger.net>
	 <web-627302724@zbackend1.aha.ru>  <4E9B9018.1000002@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Oct 2011 18:34:26 -0700
Message-ID: <1318815266.31823.31.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 19:16 -0700, Larry Finger wrote:
> On 10/16/2011 08:33 PM, werner wrote:
> > I have to wait until the friend with the laptop comes back, perhaps this week.
> > Then I can look what wireless card is in it.
> >
> > However, now I remember me: that laptop worked only good since 2.6.39 with the
> > new kernel-embedded modules. Before, it didn't work normally, i.e. on booting
> > the wireless almost never didn't switch on; only ocasionally .
> >
> >
> > And, beside of kernel 2.6.39, and the normal wifi software, I still had him to
> > install a file iwlwifi-1000-3.ucode or .5 ucode (i'm not sure, the number can
> > also be 5000), and I had the problem to search long time for that file because
> > one find only .2 or .4 in internet but what don't work at that wifi card. You
> > could improve the kernel-module so that everything is included so that one don't
> > need to search such files.
> 
> That will not happen. In fact, the trend is from having firmware be a part of 
> the driver to having it be external.
> 
> I don't know what distro you use, but mine (openSUSE) maintains a package called 
> kernel-firmware that contains all the redistributable firmware that is available 
> from tne linux-firmware git tree. If that package is installed, then you do not 
> have to search for firmware in most cases. If your distro does not have such a 
> package, then complain or find another distro.
> 
> > Then, with this kernel and that file however, it worked without any problem.
> >
> > I hope from these informations you can find out what wifi card or what driver is
> > in the laptop.
> 
> We can tell that you have an Intel card, but not much more.
> 
> Larry
> 

Not knowing much about what problem you  encounter, but you can find all
the latest intel WiFi firmware at
http://www.intellinuxwireless.org/?n=Downloads

Thanks
Wey

