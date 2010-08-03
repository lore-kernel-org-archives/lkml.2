Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0HCM3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:29:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab0HCM33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:29:29 -0400
Message-ID: <4C580B4E.1050906@suse.cz>
Date: Tue, 03 Aug 2010 14:27:58 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v2 0/3] update of various kbuild flags to allow user	settings
References: <20100728182523.GA29198@merkur.ravnborg.org> <4C51432D.3020600@suse.cz>
In-Reply-To: <4C51432D.3020600@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.7.2010 11:00, Michal Marek wrote:
> On 28.7.2010 20:25, Sam Ravnborg wrote:
>> Denys Vlasenko complained that he could not set
>> a moduel specific linker flags on the command line.
>>
>> It turned out that the cause of this was kbuild
>> that assigned a value to a variables that
>> may be modified by the user.
>> So any user supplied value would overwrite
>> the kbuild assigned value.
>>
>> Fix this so we use internal variables for kbuild
>> feering up the official variables for use by
>> the user.
> 
> Acked-by: Michal Marek <mmarek@suse.cz>
> 
> but I'll wait a while before applying it so that the arch maintainers
> can object to / ack the arch-specific changes.

Applied. I'll be sending a pull request to Linus on Wednesday.

Michal
