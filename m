Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1FJMOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:14:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60353 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab1FJMOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YqLNfVehYbp4k/V65qiBi1FTpUC1coHRjgEmwptn7amY4MUVB+La+kcgx/dmtqOLvl
         kMVMSUnyK4ZA57UvexlQQWUYvRsV25ndA2heIzI8/lRzwUZl2jTZxl9DzSX+z0gD+3BV
         z7OvkfH5tTzrEc8dpFkbiOEZr/Is/RrLj2IlI=
MIME-Version: 1.0
In-Reply-To: <87lix9dioo.fsf@rustcorp.com.au>
References: <4DEE2B15.4090809@redhat.com>
	<87lixbgax9.fsf@rustcorp.com.au>
	<4DF06F4F.8050308@redhat.com>
	<87lix9dioo.fsf@rustcorp.com.au>
Date: Fri, 10 Jun 2011 13:14:02 +0100
Message-ID: <BANLkTimqrZYnnVq5KTh3s68_o3Lfr9oWeA@mail.gmail.com>
Subject: Re: virtio scsi host draft specification, v3
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Hannes Reinecke <hare@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 12:33 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 09 Jun 2011 08:59:27 +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> On 06/09/2011 01:28 AM, Rusty Russell wrote:
>> >> >  after some preliminary discussion on the QEMU mailing list, I present a
>> >> >  draft specification for a virtio-based SCSI host (controller, HBA, you
>> >> >  name it).
>> >
>> > OK, I'm impressed.  This is very well written and it doesn't make any of
>> > the obvious mistakes wrt. virtio.
>>
>> Thanks very much, and thanks to those who corrected my early mistakes.
>>
>> > I assume you have an implementation, as well?
>>
>> Unfortunately not; "we're working on it", which means I should start in
>> July when I come back from vacation.
>>
>> Do you prefer to wait for one before I make a patch to the LyX source?
>> In the meanwhile, can you reserve a subsystem ID for me?
>>
>> Paolo
>
> Sure, you can have the next subsystem ID.
>
> It's a pain to patch once it's in LyX, so let's get the implementation
> base on what you posted here an see how much it changes first...

Paolo, I'll switch the Linux guest LLD and QEMU virtio-scsi skeleton
that I have to comply with the spec.  Does this sound good or did you
want to write these from scratch?

Stefan
