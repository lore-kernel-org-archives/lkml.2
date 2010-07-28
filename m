Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab0G1LDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 07:03:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab0G1LDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 07:03:07 -0400
Message-ID: <4C500E41.40708@suse.cz>
Date: Wed, 28 Jul 2010 13:02:25 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: trapdoor6@gmail.com
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org
Subject: Re: Small typo in kernel [current source from git] .config option
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>	<20100727165549.GC26649@merkur.ravnborg.org> <AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>
In-Reply-To: <AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.7.2010 19:12, trapDoor wrote:
> On Tue, Jul 27, 2010 at 5:55 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> On Tue, Jul 27, 2010 at 03:46:45PM +0100, trapDoor wrote:
>>> Hello,
>>> I've just got lucky and found this little typo under "Power management
>>> and ACPI options"  ---> "ACPI (Advanced Configuration and Power
>>> Interface) Support":
>>> hArdware Error Device
>>>
>>> Here is my fix:
>>> Hardware Error Device
>>> :)
>>>
>>> BTW, first time I've used nconfig instead of menuconfig. And I like it.
>>
>> The capital "A" is nconfigs way to tell you that you can use
>> "a" as shortcut to reach the menu.
> 
> Rignt! So it's just a 'mnemonic' and only appears like that in nconfig
> (I see that now). I'd guess that if I've ever made any use of
> mnemonics here.

For completeness - This affects any option that starts with H, Y, M or
N, as these letters are taken (they stand for Help, Yes, Module and No,
respectively). Unfortunatelly, there doesn't seem to be a way to
highlight single letters in an ncurses menu, hence the strange
cApitalization :(.

Michal
