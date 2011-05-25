Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1EYJY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:24:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58976 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1EYJY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:24:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6356"; a="93308814"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <011d01cc19ff$616055c0$24210140$@org> <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org> <013201cc1a96$bdda7910$398f6b30$@org> <20110525092124.GI14556@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110525092124.GI14556@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Wed, 25 May 2011 12:26:08 +0300
Message-ID: <015801cc1abd$ca534e20$5ef9ea60$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwavRYrqFpA3iX3Q06nQxFvoUUMlAAAHdUg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As I mentioned, updating all of the gadget drivers will take a long
> > time and I don't fill confident enough doing since I'm not familiar
> > with all of them and don't have the ability to test each of them
> > properly. I can add SS descriptors to f_mass_storage, g_zero if it
> > helps and of course f_uasp already has them.
> > I'm a bit confused by this actually... We've been discussing this
> > patch series for quite a while now and I got the impression that
> > except for some minor comments you were all for excepting this. Was I
> > wrong or am I misunderstanding the above?
> > In any case, I don't feel that adding SS support for the Gadget
> > framework should be delayed until all gadget drivers add SS
> > descriptors because this patch series will give the developers the
> > ability to test these gadget drivers at SS. Also, several developers
> > addressed me offline with questions on this series so I know people
> > are using it in their work. And of course we do :)
> 
> just remove the hunk which changes composite.c speed field and it
> should all be ok :-)
> 

But that's why we added the feature flag. Isn't leaving it FALSE the same as
removing the part that updates gadget speed? It is protected with #ifdef.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




