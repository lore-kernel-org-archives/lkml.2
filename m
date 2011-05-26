Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1EZFzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:55:45 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:33361 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab1EZFzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:55:44 -0400
Message-ID: <4DDDEA82.4020002@snapgear.com>
Date: Thu, 26 May 2011 15:52:02 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <uclinux-dev@uclinux.org>
Subject: Re: [PATCH 3/4] m68knommu: Make empty_zero_page "void *", like on
 m68k
References: <1306314660-19288-1-git-send-email-geert@linux-m68k.org>	<4DDDD96E.3020604@snapgear.com> <BANLkTi=QB5Hm8SWFjmYy4FUi0GZXiGC7Ew@mail.gmail.com>
In-Reply-To: <BANLkTi=QB5Hm8SWFjmYy4FUi0GZXiGC7Ew@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 26/05/11 15:11, Geert Uytterhoeven wrote:
> Hi Greg,
>
> On Thu, May 26, 2011 at 06:39, Greg Ungerer<gerg@snapgear.com>  wrote:
>> On 25/05/11 19:10, Geert Uytterhoeven wrote:
>>> This allows to get rid of the casts.
>>>
>>> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
>>
>> Looks good:
>>
>> Acked-by: Greg Ungerer<gerg@uclinux.org>
>>
>> Do you want me to add to the m68knommu git tree?
>> Or are these part of a series you intend pushing yourself?
>
> Please add it to your tree.

Done!

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
