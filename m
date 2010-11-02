Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0KBTqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 15:46:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45686 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab0KBTqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 15:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Va0HQLJ8rJEV3+SDqydGZvWPN3iNA/FG8cQSJJLikAlKiVuMi0rzRtdkfknbE7VSYZ
         KWZDAtiD14n9hoOJg9H9yLHuA6ekNDHThbdUivTQN4BqMNMzY40BvXaS7cSuC1+fauTQ
         JMvsql/Tlw18c9DgTXg8S5PXiuLW3Xb4P2e6o=
MIME-Version: 1.0
In-Reply-To: <20101102143949.GH21476@opensource.wolfsonmicro.com>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
	<1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
	<20101102131146.GA21476@opensource.wolfsonmicro.com>
	<AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
	<20101102141208.GU31158@pengutronix.de>
	<AANLkTikwGBij05h1GgW0dpvcJedmcOQ1HWCaxaBdhZta@mail.gmail.com>
	<20101102143949.GH21476@opensource.wolfsonmicro.com>
Date: Tue, 2 Nov 2010 21:46:47 +0200
Message-ID: <AANLkTik6G25x3t9W01e_LRNVRv99CbWY3GFU93mz1wEg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>, Mike Rapoport <mike@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 4:39 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Nov 02, 2010 at 04:18:18PM +0200, Felipe Contreras wrote:
>> 2010/11/2 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>
>> > Well, all platforms that have TWL4030_CORE will get REGULATOR_TWL4030 by
>> > default, too.  (TWL4030_CORE doesn't depend on something omapish.)
>
>> Yes, I think TWL4030_CORE should depend on OMAP3, but I think some
>> people might not like that. That's why I wanted to make that a
>> separate patch.
>
> It did originally but that dependency was removed to allow build
> coverage for non-OMAP users.

I'm not sure removing that dependency is worth it. There's probably a
lot of code in the kernel that can be built without meeting the
specified dependencies. Maybe there should be a way to differentiate
soft from hard dependencies for this particular use-case. But I guess
for now the lack of dependency should be ok.

-- 
Felipe Contreras
