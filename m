Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab0LMQ4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:56:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39232 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0LMQ4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:56:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ee0BRFSaxVl2mHuJWU+VS5tEhhuHSV3sL1afmLixOiRs7+/zk7OBQKVQGflT0VnOdL
         cZ8c0BKLibZ7DR49cf59/X0cVEZPkbDnnnhK5SFNTvfPcqjXO6OQ+uQ/aN8FqvLGC4v2
         MpsYFiTw1Sw23iLZl3x5eFYHHpVwFrEz33rGE=
MIME-Version: 1.0
In-Reply-To: <4D05E483.1000106@redhat.com>
References: <201012131244.547034648@firstfloor.org>
	<20101212234644.B05DAB27BF@basil.firstfloor.org>
	<4D05DC98.40105@redhat.com>
	<044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>
	<4D05E096.6060307@redhat.com>
	<74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>
	<4D05E2A5.8070204@redhat.com>
	<20101213091254.GA999@basil.fritz.box>
	<4D05E483.1000106@redhat.com>
Date: Mon, 13 Dec 2010 11:56:33 -0500
X-Google-Sender-Auth: UiqgKGzui9wcAErD2N3janH6E-E
Message-ID: <AANLkTinOWHcyjXsY3Xhe6pxi3gyQ3tJMr2qCpRPuyBW4@mail.gmail.com>
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, mst@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 4:16 AM, Avi Kivity <avi@redhat.com> wrote:
> On 12/13/2010 11:12 AM, Andi Kleen wrote:
>>
>> >  - Greg rejects kvm patches (but not virtio etc) pointing submitters
>> >  to the kvm maintainers
>> >  - The kvm maintainers collect stable kvm patches and autotest them
>>
>> As I understand this patch came in this way for .36
>> (I took it from .36-stable)
>
> The patch was autotested for .36-stable, it wasn't autotested for
> .35-stable.  It will very likely work (this isn't code that changes a lot),
> but still.
>
>> >  - They then submit the patches to stable@
>>
>> Do you want to do the autotest explicitely for .35 too and no automatic
>> backports and do the same procedure as for newer kernels?
>>
>> I can do that, but you would need to do it for a long time.
>
> Yes.  In fact it gets more important as time goes by, since as time goes by
> patches are more likely to cause regressions due to changes in the code
> base.

My workflow is largely the same as Andi's -- in that I'm using patches that
have already been nominated for other stable releases and putting them
on the 34-lt (longterm) as appropriate.  Are you interested in also doing the
same thing for 34-lt (i.e. you generating a 34 specific, pre-tested patchset
instead of me doing the backports from other stable trees?)

Thanks,
Paul.

>
> --
> error compiling committee.c: too many arguments to function
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
