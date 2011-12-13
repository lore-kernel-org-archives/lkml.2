Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1LMOMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:12:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51270 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab1LMOMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:12:03 -0500
MIME-Version: 1.0
In-Reply-To: <20111212173819.GT13952@sortiz-mobl>
References: <20111126201334.16080.85045.stgit@notabene.brown>
	<20111212173819.GT13952@sortiz-mobl>
Date: Tue, 13 Dec 2011 16:12:02 +0200
Message-ID: <CAMP44s1D+HXP_prHVwEztLCd1XJpnzukFeNKH_xEZrq06jEouA@mail.gmail.com>
Subject: Re: [PATCH 0/4] fixes for twl4030-irq in mainline
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 12, 2011 at 7:38 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Sun, Nov 27, 2011 at 07:17:41AM +1100, NeilBrown wrote:
>>   The recent tidying up of twl4030-irq seems to have left it broken.
>> At least it doesn't work for me on my gta04 (www.gta04.org).  The
>> first interrupt from the device freezes the whole system (by being
>> constantly delivered)
>>
>> The following 4 patches make it work for me and addresses some other
>> less critical issues like a typo in a comment :-)
>
> Thanks, I applied all 4 of them.

Did you apply them for 3.2 or 3.3? Without the first patch any system
that has a twl4030 chip will immediately hang on the first interrupt,
and many functions of twl4030 will just not work without the second
one.

-- 
Felipe Contreras
