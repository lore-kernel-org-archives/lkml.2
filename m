Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966921Ab2EOXCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:02:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54581 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966508Ab2EOXC2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:02:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1205142353430.20118@math.ut.ee>
References: <alpine.SOC.1.00.1204122238400.16365@math.ut.ee>
 <CAErSpo6YnzywdjTTVdVEHj_E-B0ARBpZ+fiy29Rv==fO6m9-FA@mail.gmail.com>
 <1335557685.2386.62.camel@zim.stowe> <alpine.SOC.1.00.1204280819270.14507@math.ut.ee>
 <1335905694.2386.138.camel@zim.stowe> <1336430699.2427.117.camel@zim.stowe>
 <alpine.SOC.1.00.1205131811590.7097@math.ut.ee> <20120514202147.GA20652@google.com>
 <alpine.SOC.1.00.1205142353430.20118@math.ut.ee>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 15 May 2012 16:02:06 -0700
Message-ID: <CAErSpo4zR-LGBcRXw--SVVzedCF9VdgeHD=_8A98LhvaVb0ULA@mail.gmail.com>
Subject: Re: x86: runtime waring in pcibios_fwaddrmap_lookup
To: Meelis Roos <mroos@linux.ee>
Cc: Myron Stowe <mstowe@redhat.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 1:53 PM, Meelis Roos <mroos@linux.ee> wrote:
>> > > > Thanks for the quick response Meelis (unlike myself; I've been consumed
>> > > > with a hard deadline task recently - sorry).
>> >
>> > Not so quick this time - I had to replace the HDD and then recreate the
>> > failing config. Took 2.4-rc7 as a base. This gives us another data point
>> > - it does not warn on SMP but warns only on UP.
>>
>> I think that's the critical point; thanks for mentioning it :)
>>
>> The following patch should fix it.  Can you confirm?
>
> Yes, that fixes it, thanks!

I applied this to my "next" branch.

Bjorn
