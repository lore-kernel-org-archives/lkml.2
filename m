Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab0LPWIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:08:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab0LPWIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:08:15 -0500
Message-ID: <4D0A8DCC.9040701@suse.cz>
Date: Thu, 16 Dec 2010 23:08:12 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH: Put .zdebug* section on white list
References: <AANLkTik90p-L+4_GnwXzoekCK0E2uemZD6tOK_kEFd2n@mail.gmail.com>	<4D0A866E.40708@suse.cz> <AANLkTi=Nd76X3dKAi_A3M=8tHbmgqO3DH11eo0stAQWO@mail.gmail.com>
In-Reply-To: <AANLkTi=Nd76X3dKAi_A3M=8tHbmgqO3DH11eo0stAQWO@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.12.2010 22:37, H.J. Lu wrote:
> On Thu, Dec 16, 2010 at 1:36 PM, Michal Marek<mmarek@suse.cz>  wrote:
>> On -10.1.-28163 20:59, H.J. Lu wrote:
>>>
>>> Hi,
>>>
>>> "as --compress-debug-sections" will generate compressed debug sections
>>> with section names ".zdebug*".  This patch puts .zdebug* section on
>>> white list.
>>
>> Hi,
>>
>> can I assume that the patch is
>> Signed-off-by: H.J. Lu<hjl.tools@gmail.com>
>> ?
>>
>
> Yes.

OK, applied to kbuild-2.6.git#kbuild.

Thanks,
Michal
