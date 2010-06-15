Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab0FOUtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:49:16 -0400
Received: from mother.ludd.ltu.se ([130.240.16.3]:58476 "EHLO
	mother.ludd.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab0FOUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:49:14 -0400
Cc: Doug Thompson <norsk5@yahoo.com>, Tony Luck <tony.luck@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       BrentYoung <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Nils Carlson <nils.carlson@ericsson.com>
Message-Id: <3B694326-F435-4A54-AC36-AE059AD9161D@ludd.ltu.se>
From: Nils Carlson <nils.carlson@ludd.ltu.se>
To: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100615193519.GA12845@basil.fritz.box>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: Hardware Error Kernel Mini-Summit
Date: Tue, 15 Jun 2010 22:48:06 +0200
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com> <35525.41387.qm@web50105.mail.re2.yahoo.com> <20100615065630.GC6727@basil.fritz.box> <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se> <20100615114135.GH6727@basil.fritz.box> <Pine.GSO.4.58.1006151411370.17929@dexter.ludd.ltu.se> <20100615193519.GA12845@basil.fritz.box>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2010, at 9:35 PM, Andi Kleen wrote:

>> But there are bugs. And correcting them is so prohibitively
>> expensive that I don't even want to think about it. And when
>
> Something is wrong in your setup then.

No, something is wrong with the BIOS. ;-)

<long snip>

Could you maybe give me an example from the board of your choosing
of a DMI table print out, explain the format and then show how to use  
it?
I'd like to show it to our BIOS writers. Ideally, maybe somebody could
post a good suggestion for a standardized format? (Though that's very
optimistic, but maybe cpu vendors can make suggestions to board makers?)

/Nils
