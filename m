Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1DOOPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:15:08 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:51697 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1DOOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:15:07 -0400
Message-ID: <4DA852E3.9080702@ece.ntua.gr>
Date: Fri, 15 Apr 2011 17:14:59 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110407 Lightning/1.0b3pre Lanikai/3.1.9
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Two questions about paravirt boot sequence(head_32.S)
References: <4DA6CD8F.6080206@ece.ntua.gr> <8762qhavaa.fsf@rustcorp.com.au> <20110415140846.GA32334@dumpdata.com>
In-Reply-To: <20110415140846.GA32334@dumpdata.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (ulysses.noc.ntua.gr [147.102.222.230]); Fri, 15 Apr 2011 17:15:01 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 05:08 PM, Konrad Rzeszutek Wilk wrote:
> On Thu, Apr 14, 2011 at 09:40:05PM +0930, Rusty Russell wrote:
>> On Thu, 14 Apr 2011 13:33:51 +0300, Stratos Psomadakis <psomas@ece.ntua.gr> wrote:
>>> 2)I think that xen doesn't use any more the hardware subarch boot
>>> parameter, and uses a 'different' path/boot sequence, hence the
>>> xen_entry in head_32.S is not needed any more. Am I missing something?
>> Yep, Xen never actually used it.
> Does lguest use it? It looked like a neat idea - what happened?
yeap, afaik, lguest uses the subarch field to jump to its own 'entry
point'...

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

