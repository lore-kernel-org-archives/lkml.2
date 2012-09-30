Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab2I3PQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 11:16:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49780 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751032Ab2I3PQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 11:16:04 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/WF/AM7gnWm8zSXHLj3NPIsfDfOmouuOHXlPjSov
	/mlk6fhsOB32o5
Message-ID: <50686231.3020700@gmx.de>
Date: Sun, 30 Sep 2012 17:16:01 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>
Subject: Re: hot CPU with 3.6.0-rc7+ and intel graphic
References: <5066AD45.70107@gmx.de> <5066AE4B.9090000@gmx.de> <20120930213743.69e13db1@feng-i7>
In-Reply-To: <20120930213743.69e13db1@feng-i7>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2012 03:37 PM, Feng Tang wrote:
> Hi Toralf,
 Really weird, my commit only change the lpc_ich.c which affects the TCO_WDT
> driver. but from your .config file, neither CONFIG_LPC_ICH nor the
>  CONFIG_ITCO_WDT is enabled, which means the commit should not affect
> your kernel, could you double check the .config file?
> 
> Thanks,
> Feng

I accidently forgot (at least one time) to mount the external /boot
partition before installing teh test kernel image - therefore both
bisecting (and the revert of the "guilty" commit" to double check it)
were done using a wrong test case

:-[

Sry for the noise - and the waste of time - grr.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
