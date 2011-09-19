Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab1ISSCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:02:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60342 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab1ISSCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:02:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tjSp+pZrSDP0MHzmaVMsZJ4yfnD1c3srr3AwD7ilByEB0LYk/hGQqZlr3jEr94IsM
	ONkAWq8WyC2YPbHrEe4Rg==
MIME-Version: 1.0
In-Reply-To: <20110919165943.GX16381@n2100.arm.linux.org.uk>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
	<CAH+eYFBSiL44CMOpgED+TAOTUH_dQMaKKu=hC3ynG0Y2nQ8ekw@mail.gmail.com>
	<CAB-zwWi1K8y8fHzy0hgcFPgSfhMrZNfoKQ9xuU00Y1sLg6ZBmw@mail.gmail.com>
	<20110919144313.GU16381@n2100.arm.linux.org.uk>
	<20110919165943.GX16381@n2100.arm.linux.org.uk>
Date: Mon, 19 Sep 2011 11:02:08 -0700
X-Google-Sender-Auth: WMAk3qBwdzTsAMthlKbavMEpQaQ
Message-ID: <CAPnjgZ1JDGt7Dzp9VrRKKApeZ9RT9oqry+UkQZwVCw1P+t9pew@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
From: Simon Glass <sjg@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Ramirez Luna, Omar" <omar.ramirez@ti.com>, Rabin Vincent <rabin@rab.in>,
        lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Mon, Sep 19, 2011 at 9:59 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Sep 19, 2011 at 03:43:13PM +0100, Russell King - ARM Linux wrote:
>> On Mon, Sep 19, 2011 at 09:26:49AM -0500, Ramirez Luna, Omar wrote:
>> > Hi
>> >
>> > On Sat, Sep 17, 2011 at 1:07 AM, Rabin Vincent <rabin@rab.in> wrote:
>> > > If the "Use generic BUG() handler" patch is only scheduled for the next
>> > > merge window and not for 3.1, can this patch be merged instead for 3.1
>> > > and -stable?  This problem is easily seen with GCC 4.6.
>> >
>> > I can send it for both and let the maintainers decide.
>> >
>> > Russell, do you give your ack?
>>
>> I think it's too large a change for -stable and 3.1 - let's get it into
>> 3.2 first, and make sure no one sees any regressions there.  Then we can
>> think about submitting it to stable once its proven itself.
>
> And we're seeing link failures with the patch in the kernel, so it's
> *definitely* not stable material as it stands, even if the current code
> is a problem for GCC 4.6.
>
> Regressions trump bug fixes.

Can you point me to the link failures please?

Regards,
Simon

>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
