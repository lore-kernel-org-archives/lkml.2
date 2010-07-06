Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0GFPwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:52:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36965 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0GFPwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:52:40 -0400
Message-ID: <4C33513C.4090704@ti.com>
Date: Tue, 6 Jul 2010 10:52:28 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: Greg KH <greg@kroah.com>, Ohad Ben-Cohen <ohad@wizery.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Hebbar, Shivananda" <x0hebbar@ti.com>,
       "Ramos Falcon, Ernesto" <ernesto@ti.com>, "Anna, Suman" <s-anna@ti.com>,
       "Kanigeri, Hari" <h-kanigeri2@ti.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, "Gupta, Ramesh" <grgupta@ti.com>,
       "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
       Tony Lindgren <tony@atomide.com>,
       Ameya Palande <ameya.palande@nokia.com>,
       "Gomez Castellanos, Ivan" <ivan.gomez@ti.com>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       "Uribe de Leon, Armando" <x0095078@ti.com>,
       "Chitriki Rudramuni, Deepak" <deepak.chitriki@ti.com>,
       "Menon, Nishanth" <nm@ti.com>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       "Pitney, Gilbert" <gpitney@ti.com>, "Shah, Bhavin" <bshah@ti.com>
Subject: Re: [PATCH 11/11] staging: ti dspbridge: enable driver building
References: <1277298125-17991-1-git-send-email-ohad@wizery.com>	<1277298840-18516-1-git-send-email-ohad@wizery.com>	<20100623224150.GA6680@kroah.com> <AANLkTik0rm12w4jplD1vSTZnPbwguDU6xtOdAfs9C-3r@mail.gmail.com>
In-Reply-To: <AANLkTik0rm12w4jplD1vSTZnPbwguDU6xtOdAfs9C-3r@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/4/2010 5:53 AM, Felipe Contreras wrote:
> On Thu, Jun 24, 2010 at 1:41 AM, Greg KH<greg@kroah.com>  wrote:
>> The default is always 'n' so you don't need this.
>>
>> Also, this enables the driver to be built on x86, which fails horribly,
>> and I don't think is what you really want to have happen :)
>>
>> So I need some more Kconfig changes here, care to redo just this one
>> patch?  I've applied all the others and they will show up in linux-next
>> tomorrow.
>
> I fixed all that stuff some time ago:
> http://article.gmane.org/gmane.linux.ports.arm.omap/36065
>
> But the patches were ignored.

Patches were not ignored, discussion was held privately (you and me), 
patch 13 was not accepted because changing indentation doesn't deserve a 
copyright assignment (IMHO), at that point *you* wanted your patches not 
to be included if the last one wasn't merged in.

- omar

