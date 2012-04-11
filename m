Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2DKIBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:01:38 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:39013 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab2DKIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:01:37 -0400
Message-ID: <4F8539FC.4030503@st.com>
Date: Wed, 11 Apr 2012 13:29:56 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alim Akhtar <alim.akhtar@gmail.com>
Subject: Re: [PATCH 2/2] dma/amba-pl08x: add support for the Nomadik variant
References: <1334004816-20219-1-git-send-email-linus.walleij@linaro.org> <4F83AC55.3070900@st.com> <CACRpkdaz9g7cRc1rAMHUzRbLcrYtB-kPCB6bFEMYZxxmWfLNSg@mail.gmail.com>
In-Reply-To: <CACRpkdaz9g7cRc1rAMHUzRbLcrYtB-kPCB6bFEMYZxxmWfLNSg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2012 1:29 PM, Linus Walleij wrote:
>>> >> +                             ch->locked = true;
>>> >> +                     } else
>>> >> +                             ch->locked = false;
>>> >> +             }
>>> >> +
>> >
>> > Memory for ch is allocated with kmalloc and so its default value is garbage.
>> > So we must set locked to false in else part here.
> Hm maybe better to kzalloc() the channel structs?
> 

Then, you can remove code which makes its field zero explicitly, as it is already
zero.

-- 
viresh
