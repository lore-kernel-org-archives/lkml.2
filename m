Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab2KHQ5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 11:57:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413Ab2KHQ5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 11:57:06 -0500
Message-ID: <509BE45E.6010309@redhat.com>
Date: Thu, 08 Nov 2012 08:57:02 -0800
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120825 Thunderbird/10.0.7
MIME-Version: 1.0
To: Jon Mason <jdmason@kudzu.us>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Fleischmann <mwf@risingtidesystems.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: Re: scsi target, likely GPL violation
References: <509A915B.30105@redhat.com> <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
In-Reply-To: <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 05:02 PM, Jon Mason wrote:
> On Wed, Nov 7, 2012 at 9:50 AM, Andy Grover <agrover@redhat.com> wrote:
>> Your company appears to be shipping kernel features in RTS OS that are
>> not made available under the GPL, specifically support for the
>> EXTENDED_COPY and COMPARE_AND_WRITE SCSI commands, in order to claim
>> full Vmware vSphere 5 VAAI support.
>>
>> http://www.risingtidesystems.com/storage.html
>> http://www.linux-iscsi.org/wiki/VAAI
>>
>> Private emails to you and RTS CEO Marc Fleischmann have not elicited a
>> useful response.
>>
>> You are subsystem maintainer for the in-kernel SCSI target support
>> (drivers/target/*), and your company appears to be violating the GPL.
> 
> The peanut gallery needs more information, as this is quite an
> incendiary claim to be making on a Linux kernel forum.  How are they
> violating the GPL?  I'm not a lawyer, nor do I play one on TV, but if
> I understand the GPL correctly, RTS only needs to provide the relevant
> source to their customers upon request.  Are there customers (perhaps
> Redhat) that they have not provided this to?  If so, then they need to
> be publicly shamed (gpl-violations.org would be a good place to go as
> well).  If not, then they are within their rights to behave the way
> they are currently behaving.
> 
> Again, we need more info before we start flinging the tomatoes at them.

Look at the marketing material on their website. They demonstrate how
RTS OS fully implements vSphere 5 VAAI features. We know to a very high
certainty that this must have been implemented with kernel code, so
therefore this must be a GPL violation, since these changes have not
been made public.

-- Andy
