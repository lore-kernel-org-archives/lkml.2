Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1KTNgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 08:36:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab1KTNgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 08:36:10 -0500
Message-ID: <4EC9024A.7070807@suse.cz>
Date: Sun, 20 Nov 2011 14:36:10 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "konrad.gaisler" <konrad@gaisler.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org,
        linux kbuild list <linux-kbuild@vger.kernel.org>, pefoley2@verizon.net,
        yann.morin.1998@anciens.enib.fr, sam@ravnborg.org,
        zippel@linux-m68k.org
Subject: Re: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
References: <1321625774-12749-1-git-send-email-konrad@gaisler.com> <4EC69F65.20207@xenotime.net> <4EC6E179.1030703@gaisler.com> <CACqU3MV=XzNUv70vP7QtQwC2xgqnY0bX+orDA+aErmJGwdEA_w@mail.gmail.com> <4EC76049.8020508@gaisler.com>
In-Reply-To: <4EC76049.8020508@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.11.2011 08:52, konrad.gaisler wrote:
> On 11/19/2011 07:23 AM, Arnaud Lacombe wrote:
>> On Fri, Nov 18, 2011 at 5:51 PM, konrad.gaisler<konrad@gaisler.com>  wrote:
>>> As an example, apply the patch, then add to<top>/Kconfig the lines:
>>>
>>> subsource "arch/sparc/Kconfig" "." ".config_sparc" "SPARC config" SPARC_
>>> CONFIG_
>>> subsource "arch/mips/Kconfig" "." ".config_mips" "MIPS config" MIPS_ CONFIG_
>>>
>> ETOOMUCHARGUMENT!
>>
>> I wonder if we could not get all these parameters specified
>> dynamically in the Kconfig. This would replace the `mainmenu' entry
>> ala:
>>
>> config
>>      title "Linux ..."
>>      prefix "CONFIG_"
>>      file .config
>> endconfig
> Yes maybe it can be done that way. Personally I think it is
> more difficult.

A <command> <argument> syntax fits well into the existing Kconfig
language and it more readable, as you don't have to count the position
of the arguments and check their meaning in the documentation.

Michal
