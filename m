Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2ECOMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:12:15 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:35711 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2ECOMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:12:13 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiN3APiRok9V5qg+PGdsb2JhbABEii+nIQSBIRkBAQEBNzSCCQEBBAE6HCMQCANGFCUKGogbCbo7E4sVhH1jBJV9hgaNJw
X-IronPort-AV: E=Sophos;i="4.75,524,1330902000"; 
   d="scan'208";a="109416796"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 3 May 2012 16:16:51 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Chatty <chatty@enac.fr>
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
Message-ID: <20120503141651.GA12157@polaris.bitmath.org>
References: <CAN+gG=GGVFDgf_PkovS+_OX26LH0Q19_FwwkGP2pSwnoX4d_Ug@mail.gmail.com>
 <alpine.LNX.2.00.1205021044240.14613@pobox.suse.cz>
 <CAN+gG=HHxzYPSD+1i5JS8HmkxusHi=e6im48VzXHy2KsFoce+w@mail.gmail.com>
 <CAN+gG=HDZJf+73SoddWar_pRPH2NvFrvpVuAaRC8_frXmGQYfA@mail.gmail.com>
 <20120503122359.GA11552@polaris.bitmath.org>
 <CAN+gG=GS_aQ35ekF71oCjZXquB4X3xJvzq2_fT2d7nM+iBK=Zg@mail.gmail.com>
 <20120503131904.GA11741@polaris.bitmath.org>
 <CAN+gG=GU8NGJ70Yx8_roeA4LCohcmym7wEspbv4d_xMqbrP5hw@mail.gmail.com>
 <20120503135452.GA12050@polaris.bitmath.org>
 <CAN+gG=F3c-hUqzyOv7DEkWYBN6=mATVMGSKOr-MrWvid8mc-hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=F3c-hUqzyOv7DEkWYBN6=mATVMGSKOr-MrWvid8mc-hA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I suppose what you describe here is how it was working before the
> > device groups.
> 
> Just to be clear: no, this last paragraph occurs after device groups.
> Before, it was working as hid-generic catch the device first, then
> released it while looking at the report descriptors. Now, it's purely
> dependent on which driver is loaded first for this particaular case.

Thanks for the clarification, and I agree. It also means you are
completely right, it will suffice to change those devices from the
wildcard group to the multitouch group. I don't mind switching them
all.

Thanks,
Henrik
