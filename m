Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab1CDWTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:19:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40746 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445Ab1CDWTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:19:50 -0500
Message-ID: <4D71657A.4060604@zytor.com>
Date: Fri, 04 Mar 2011 14:19:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: David Johnston <dj@deadhat.com>, tytso@mit.edu,
        richard.weinberger@gmail.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: Why is my copyright code in the linux kernel?
References: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com>	<AANLkTimg1x56B4Yu=Zsd0VEci2i4jRKaMU+gxv3oFVr8@mail.gmail.com>	<20110301235433.GD2959@thunk.org>	<4D6EBC04.5050709@zytor.com>	<4D7078C8.8050009@deadhat.com>	<4D70880C.4000209@zytor.com> <AANLkTim6utrJZ-jVJdNJA6Ea_f8xQ-eAaGX8yfBaT9oc@mail.gmail.com>
In-Reply-To: <AANLkTim6utrJZ-jVJdNJA6Ea_f8xQ-eAaGX8yfBaT9oc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 02:16 PM, Yinghai Lu wrote:
> On Thu, Mar 3, 2011 at 10:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 03/03/2011 09:29 PM, David Johnston wrote:
>>> Yes I am willing to allow you to retain it.
>>> I guess, to be all legalese..
>>>     I herein permit you to use any 802.11 related C code taken from the
>>> www.deadhat.com website, in the linux kernel, and to publish it under
>>> the terms of version 2 of the GNU General Public License.
>>>
>>> Yes I've emailed ralink and VIA. I hope they're nice people.
>>
>> First of all, thank you (both for the code and for being reasonable.)
>>
>> It sounds like this might simply have been an honest misreading.
>>
> 
> interesting.
> 
> in the git history, some functions take IN/OUT macro.
> 
> -VOID AES_GTK_KEY_UNWRAP(IN UCHAR * key,
> -                       OUT UCHAR * plaintext,
> -                       IN UINT32 c_len, IN UCHAR * ciphertext)
> 
> so they had driver for other os at first, and ported that one to Linux later ?
> 

It's a staging driver for a reason...

	-hpa

