Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1EGTmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 15:42:19 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:44048 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab1EGTmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 15:42:17 -0400
X-Spam-Processed: mail.academy.zt.ua, Sat, 07 May 2011 22:42:06 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-HashCash: 1:20:110507:md50000002757::L6wI/nb04DA6swLx:00007Lod
X-Return-Path: prvs=110837b279=george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
	driver
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTik9FWgzpNWuMXXRjOj-rDvPNY_nCA@mail.gmail.com>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	 <201105061605.31625.arnd@arndb.de>
	 <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	 <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	 <1304790665.13983.10.camel@dev.znau.edu.ua>
	 <BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com>
	 <1304792795.13983.28.camel@dev.znau.edu.ua>
	 <BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
	 <1304794931.13983.44.camel@dev.znau.edu.ua>
	 <BANLkTik9FWgzpNWuMXXRjOj-rDvPNY_nCA@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 07 May 2011 22:35:56 +0300
Message-Id: <1304796956.13983.65.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll ask linux-wireless instead of linux-usb or linux-arm.
If you know you haven't got wireless working by some reason you will ask
at linux-wireless anyway. And people there will ask you for id/ven/rev
rather than core name reported by bus driver.

> I didn't expect longer discussion so I got this trivial example of
> pr_err. But it appears to be good example/question.
> 
> How do you see relation between bcma_device_name and:
> int zd_ioread32v_locked(...) {
> 	if (r) {
> 		dev_dbg_f(zd_chip_dev(chip),
> 			  "error: zd_ioread16v_locked. Error number %d\n", r);
> 		return r;
> 	}
> }
No relation at all. It like comparing warm and soft. It will be if you
do something like

dbg_bcma_device_name
{
#ifdef DEBUG
		case/switch/if/else stuff
#endif
		return NULL;
}
But I don't see here much sense to hardcode names other than those of
buscommons/buscores for debugging purposes.

> 
> I believe according to your theory we should drop thi error message,
> right? It eats memory to keep this string while error code can always
> be checked in source.
> 
My theory ? o.O

Have nice day,
George


