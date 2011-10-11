Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1JKTsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:48:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab1JKTsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:48:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=g4mMbCvS1CVBUYa/mIivprq5g57l4IO4ucw8LoqFl5Cd1pAp4xhbmuFaLYL67CsSF
	6ljkixzQJ1MQMQPqgYRKw==
MIME-Version: 1.0
In-Reply-To: <20111011192447.GC1112@kroah.com>
References: <20111011165903.GA30976@kroah.com> <20111011165708.466042477@pistachio.kroah.org>
 <20111011172019.GI10838@kvack.org> <CAErSpo6JFTm4y35Nz7aNUgM3ynX52fM1-AwX7OTOwm3cminv1Q@mail.gmail.com>
 <20111011192447.GC1112@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Oct 2011 13:47:47 -0600
Message-ID: <CAErSpo47Yw3Vygs5=OVmtUuLsB9FxJeYBm20UYem-Z3L7B0UhQ@mail.gmail.com>
Subject: Re: [01/38] PCI: Set PCI-E Max Payload Size on fabric
To: Greg KH <greg@kroah.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 1:24 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Oct 11, 2011 at 12:14:05PM -0600, Bjorn Helgaas wrote:

>> It's not obvious that this fits the criteria for -stable
>> (Documentation/stable_kernel_rules.txt).
>>
>> For example, I can't tell what real problem this fixes.
>
> Yeah, it's not obvious, but I have had a lot of reports that 3.0 does
> not work on some systems without this set of patches.  Now figuring out
> of those same systems ever worked at all is getting to be quite
> difficult as I don't have access to the hardware, and the people that do
> aren't responding to test requests.  But from what I gather, 2.6.32 did
> work on these boxes, so it is a regression somehow, but I am not
> positive of this.

I'd like to know more about this regression.

> Now I'm very open to pushback, and if people really don't want these in
> (i.e. the PCI maintainer(s) say no), then I'll drop them and work with
> the distros to get them into their trees so that their customers's
> systems will work properly.

If distros want these patches, does that mean they have bug reports?
URLs to them would be helpful.

I just haven't seen any concrete information that says -stable will be
better off if it includes these patches.  We've tripped over enough
problems upstream that I'm concerned they might make things worse
rather than better.

Bjorn
