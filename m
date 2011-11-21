Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1KULLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:11:23 -0500
Received: from mail202c2.megamailservers.com ([69.49.111.103]:56827 "EHLO
	mail202c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755234Ab1KULLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:11:22 -0500
X-Authenticated-User: konrad.gaisler.com
Message-ID: <4ECA2FF6.2090708@gaisler.com>
Date: Mon, 21 Nov 2011 12:03:18 +0100
From: Konrad Eisele <konrad@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110928 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Arnaud Lacombe <lacombar@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org,
        linux kbuild list <linux-kbuild@vger.kernel.org>, pefoley2@verizon.net,
        yann.morin.1998@anciens.enib.fr, sam@ravnborg.org,
        zippel@linux-m68k.org
Subject: Re: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
References: <1321625774-12749-1-git-send-email-konrad@gaisler.com> <4EC69F65.20207@xenotime.net> <4EC6E179.1030703@gaisler.com> <CACqU3MV=XzNUv70vP7QtQwC2xgqnY0bX+orDA+aErmJGwdEA_w@mail.gmail.com> <4EC76049.8020508@gaisler.com> <4EC9024A.7070807@suse.cz>
In-Reply-To: <4EC9024A.7070807@suse.cz>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=t6P6ZnH7F4B+FTDzBT2sv7Wly1PyMf9jGdjNuUfj6/c= c=1 sm=1
		a=CIB-vgOadyEA:10 a=wd-vcygihCUA:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=ebG-ZW-8AAAA:8 a=CG28bE0e01zX-QE1ZqEA:9
		a=wPNLvfGTeEIA:10 a=cCYF7-FHeg4A:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek wrote:
> On 19.11.2011 08:52, konrad.gaisler wrote:
>> On 11/19/2011 07:23 AM, Arnaud Lacombe wrote:
>>> On Fri, Nov 18, 2011 at 5:51 PM, konrad.gaisler<konrad@gaisler.com>  wrote:
>>>> As an example, apply the patch, then add to<top>/Kconfig the lines:
>>>>
>>>> subsource "arch/sparc/Kconfig" "." ".config_sparc" "SPARC config" SPARC_
>>>> CONFIG_
>>>> subsource "arch/mips/Kconfig" "." ".config_mips" "MIPS config" MIPS_ CONFIG_
>>>>
>>> ETOOMUCHARGUMENT!
>>>
>>> I wonder if we could not get all these parameters specified
>>> dynamically in the Kconfig. This would replace the `mainmenu' entry
>>> ala:
>>>
>>> config
>>>      title "Linux ..."
>>>      prefix "CONFIG_"
>>>      file .config
>>> endconfig
>> Yes maybe it can be done that way. Personally I think it is
>> more difficult.
> 
> A <command> <argument> syntax fits well into the existing Kconfig
> language and it more readable, as you don't have to count the position
> of the arguments and check their meaning in the documentation.
> 
> Michal
> 
> 

Ok, I'll do it with "Config" and type "title". It will
take a while until I have a new patch...
-- Konrad
