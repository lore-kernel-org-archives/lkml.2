Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2ICB7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:59:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56039 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab2ICB7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:59:50 -0400
References: <1346319009.951368.767015086462.1.gpush@pecola> <503FA15F.7070506@zytor.com> <50400859.2080606@canonical.com> <5e40036f-b0da-47f3-acba-5dea9fdb7ed6@email.android.com> <50440A5A.900@canonical.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <50440A5A.900@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC,PATCH] efi: Add support for a UEFI variable filesystem
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 02 Sep 2012 18:59:37 -0700
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matt Domsch <Matt_Domsch@Dell.com>
Message-ID: <9741b1ed-c285-4f89-b60d-337140194345@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, appending is an action, not really a property of the variable that sticks around, no?

Jeremy Kerr <jeremy.kerr@canonical.com> wrote:

>hi hpa,
>
>> Wouldn't that be better handled by O_APPEND?
>
>Possibly, but this then means that there are now two "interfaces" that
>specify the variable attributes.
>
>[Also, in that case we should support the same mechanism through
>open();
>llseek(0, SEEK_END) then, right?]
>
>In general, I think the attributes-in-a-header mechanism is a little
>tidier than providing them in the filename. For instance, finding if a
>variable exists from userspace will require iterating the dentries (or
>trying all combinations of variables), if the attributes aren't known.
>
>However, I'm happy to implement this if it's the generally-preferred
>solution.
>
>Cheers,
>
>
>Jeremy

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
