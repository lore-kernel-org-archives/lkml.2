Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1FXRPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 13:15:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60574 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1FXRPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 13:15:09 -0400
Message-ID: <4E04C5EC.2090602@zytor.com>
Date: Fri, 24 Jun 2011 10:14:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rick van Rein <rick@vanrein.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Craig Bergstrom <craigb@google.com>,
        Andi Kleen <andi@firstfloor.org>, Stefan Assmann <sassmann@kpanic.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
References: <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de> <20110623141222.GA30003@srcf.ucam.org> <4E035DD1.1030603@kpanic.de> <20110623170014.GN3263@one.firstfloor.org> <987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com> <BANLkTikTTCU3eKkCtrbLbtpLJtksehyEMg@mail.gmail.com> <20110624080535.GA19966@phantom.vanrein.org> <4E04B848.6000908@zytor.com> <987664A83D2D224EAE907B061CE93D5301E942ED99@orsmsx505.amr.corp.intel.com> <20110624165612.GC31887@phantom.vanrein.org>
In-Reply-To: <20110624165612.GC31887@phantom.vanrein.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 09:56 AM, Rick van Rein wrote:
> Hello,
> 
>> Does it scale? [...] Perhaps we may end up with a composite solution. 
> 
> If I had my way, there would be an extension to the e820 format to allow
> the BadRAM patterns to be specified.  Since the extension with bad page
> information is specific to boot loader interaction, this would work in
> exactly those cases that are covered by the current situation.
> 

Yes, a different table might be worthwhile.

Another question, however, is what does this look like at runtime.  In
particular, if I'm not mistaken hwpoison will create struct pages for
these non-memory pages, which seems undesirable...

	-hpa

