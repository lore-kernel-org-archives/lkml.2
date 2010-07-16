Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966197Ab0GPVDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 17:03:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21885 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0GPVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 17:03:42 -0400
Message-ID: <4C40C83E.2090900@kernel.org>
Date: Fri, 16 Jul 2010 13:59:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Damien Wyart <damien.wyart@free.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kmemleak, cpu usage jump out of nowhere
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com> <1279100846.8592.53.camel@e102109-lin.cambridge.arm.com> <4C3D89AC.4040303@cs.helsinki.fi> <1279205891.6664.46.camel@e102109-lin.cambridge.arm.com> <AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com> <4C3F2F52.2050101@cs.helsinki.fi> <20100715162805.GA10240@brouette> <20100715191638.GA3694@brouette> <AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com> <20100715200012.GA4175@brouette> <F37ABC5E-E9F9-43BD-989E-4185135217D2@gmail.com> <AANLkTimWFTUZTh2-3Bavmwcum2joQluMEDmXx3xjyHqQ@mail.gmail.com> <AANLkTinqZs11kXx5afD4RDsVsy551S5lMnyAUwhdX2Sg@mail.gmail.com> <AANLkTilv7cG9JMkZeO_GftTPWHxiIY5c8Q19pTBZT7Vy@mail.gmail.com> <AANLkTimGMUtzgO5HWHXX5RY-EDET61j6PxzwgILigIef@mail.gmail.com> <4C40271E.9070809@cs.helsinki.fi> <AANLkTimxDBusBSkL0I2g9tsj4gLHaqVFArqcfixfzePh@mail.gmail.com> <4C40A498.5060208@kernel.org> <C36A97B2-E6A4-409D-91B8-DED8B086A479@gmail.com>
In-Reply-To: <C36A97B2-E6A4-409D-91B8-DED8B086A479@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C40C8F4.0038,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 01:29 PM, Zeno Davatz wrote:
> 
> Am 16.07.2010 um 20:27 schrieb Yinghai Lu <yinghai@kernel.org>:
> 
>> it seems that you are using 32bit kernel. please check if this one help.
> 
> Thanks! What RC should I patch? 2.6.35-rc5?

current linus tree or 2.6.35-rc5.

Thanks

Yinghai
