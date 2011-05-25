Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1EYEo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 00:44:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19042 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1EYEo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 00:44:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6356"; a="93461855"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <balbi@ti.com>, "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <011d01cc19ff$616055c0$24210140$@org> <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Wed, 25 May 2011 07:46:38 +0300
Message-ID: <013201cc1a96$bdda7910$398f6b30$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwaHcBTzBwd+PMnQrS3GlBION5cvAAd2MRA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Actually if the CONFIG_USB_GADGET_SUPERSPEED is turned off, which is
> the
> > default of it, the speed won't be updated and all these series won't
> be
> > functional so I don't see any possibilities for failure in such
> > configuration. Or am I missing something?
> 
> dummy_hcd should work when CONFIG_USB_GADGET_SUPERSPEED is enabled,
> even if the usb_gadget_driver structure is initialized with the speed
> field set to USB_SPEED_HIGH.  This will be true for all the standalone
> gadget drivers until they are updated.

It does.

> 
> Which leaves a question about the composite gadget framework.  Should
> it be updated with SS support?  Probably not until the various function
> drivers have all been updated.

As I mentioned, updating all of the gadget drivers will take a long time and
I don't fill confident enough doing since I'm not familiar with all of them
and don't have the ability to test each of them properly. I can add SS
descriptors to f_mass_storage, g_zero if it helps and of course f_uasp
already has them.
I'm a bit confused by this actually... We've been discussing this patch
series for quite a while now and I got the impression that except for some
minor comments you were all for excepting this. Was I wrong or am I
misunderstanding the above?
In any case, I don't feel that adding SS support for the Gadget framework
should be delayed until all gadget drivers add SS descriptors because this
patch series will give the developers the ability to test these gadget
drivers at SS. Also, several developers addressed me offline with questions
on this series so I know people are using it in their work. And of course we
do :)

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum






