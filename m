Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1F2QGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:06:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2988 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab1F2QGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:06:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=XbLGClb6jmaBUPGm5d1KrIurKhytp8x1oe5YxzEcKJ+sdGCC2Rc7ejjgFPkNBcqfv
	7vK4E3D10Nmp4ChJagiFg==
MIME-Version: 1.0
In-Reply-To: <BANLkTikw9bnrurUo8n-6yUwwQ0zOv5iAOBDt=T6Nm6nkUd7vLA@mail.gmail.com>
References: <fa.fHPNPTsllvyE/7DxrKwiwgVbVww@ifi.uio.no>
	<532cc290-4b9c-4eb2-91d4-aa66c01bb3a0@glegroupsg2000goo.googlegroups.com>
	<BANLkTik3mEJGXLrf_XtssfdRypm3NxBKvkhcnUpK=YXV6ux=Ag@mail.gmail.com>
	<20110629080827.GA975@phantom.vanrein.org>
	<BANLkTikw9bnrurUo8n-6yUwwQ0zOv5iAOBDt=T6Nm6nkUd7vLA@mail.gmail.com>
Date: Wed, 29 Jun 2011 09:06:11 -0700
Message-ID: <BANLkTi=2ZMmrwMrnyEyEZAEsCUQNnd5n1j8J0xzSEF=ahrJmLw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Craig Bergstrom <craigb@google.com>
To: linux-kernel@vger.kernel.org, fa.linux.kernel@googlegroups.com
Cc: Rick van Rein <rick@vanrein.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stefan Assmann <sassmann@kpanic.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        Nancy Yuen <yuenn@google.com>, Michael Ditto <mditto@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My apologies, I send this initial reply from the wrong address. Please
reply to this @google.com address.

Cheers,
CraigB

On Wed, Jun 29, 2011 at 8:28 AM, craig lkml <craig.lkml@gmail.com> wrote:
> Hi Rick,
> Thanks for your response.  My sincere apologies for not posting the work
> directly.
> My intention is to point interested parties to contributions that Google has
> made to this space through known and respected channels.  The cited research
> is not my research but the research of my colleagues.  As a result, I
> hesitate to paraphrase the work as I will likely get the details wrong.  In
> any case, Shane's points are the most relevant for the discussion here.
>  Please refer to his post in this thread.
> In an attempt to contribute to the community as much as I can, I have
> prepared and mailed our BadRAM patch as requested.  In case it is not
> otherwise clear, my belief is that the ideal solution for the upstream
> kernel is a hybrid of our approaches.
> Thank you,
> CraigB
>
> On Wed, Jun 29, 2011 at 1:08 AM, Rick van Rein <rick@vanrein.org> wrote:
>>
>> Hello Craig,
>>
>> > Some folks had mentioned that they're interested in details about what
>> > we've learned about bad ram from our fleet of machines.  I suspect
>> > that you need ACM portal access to read this,
>>
>> I'm happy that this didn't cause a flame, but clearly this is not the
>> right response in an open environment.  ACM may have copyright on the
>> *form* in which you present your knowledge, but could you please poor
>> the knowledge in another form that bypasses their copyright so the
>> knowledge is made available to all?
>>
>>
>> Thanks,
>>  -Rick
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
