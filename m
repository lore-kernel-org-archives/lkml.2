Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0FQAg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:36:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44492 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0FQAg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:36:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=V3cEfqAA+i+I3zsC8WKqlcUGNaD4A2K0dl4IOrUWgneD8kZ0Yh8BmxiN962Ofp4aFi
         MGbAnnGojTTCJ5sj0iOPUcnY6XnsP9ISQw41NQSmfVcYCBkqAXtzFbXc82d1p6a2m528
         1k7ppVmoVKfkw1czY9zIR9xudnELWyTTz1sZQ=
MIME-Version: 1.0
In-Reply-To: <1276373081.4c13e859a61fc@imp.free.fr>
References: <1276360709.4c13b80507f8b@imp.free.fr>
	<1276373081.4c13e859a61fc@imp.free.fr>
Date: Wed, 16 Jun 2010 20:36:27 -0400
Message-ID: <AANLkTillLDLJdk0CU9TR-9eB5cPrNlBXejgFwUG2vuGv@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Set first MB as RW+NX
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: castet.matthieu@free.fr
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Special accommodations have been made for BIOS32/PCI BIOS services:
>> > according to BIOS32 specification
>> > (http://members.datafast.net.au/dft0802/specs/bios32.pdf), at most two
>> > pages per BIOS32 service should be set executable and no pages need to
>> > be writeable.
>> From my understanding only the service directory take 2 pages.
>>
>> The no info for the pci service :
>> - the length field could be used to find the number of page it takes.
>> - could we assume data ro ?
>>
>
> http://members.datafast.net.au/dft0802/specs/bios21.pdf got all info for pci
> bios [1].
> So I was right : we shouldn't assume pci bios routine take only 2 pages, but use
> the length parameter.

Thanks for looking into this. I will be posting another patch shortly.
