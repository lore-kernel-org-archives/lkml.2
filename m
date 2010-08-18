Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0HRQT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:19:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39687 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0HRQT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ktA12aNCjwpLfFj1H8AKzfaVGHLtTHNHXAi6yZ1PV6Y9m6xx5R0Sbfr0gqSt1DzmJn
         /FIlzjMgk3ZXkxt/+oFQBJi50Z66QdkBz5gfvx9WwHl/Dl9KPYg0uWNC0sGC+kQdVNRV
         jisoJMuYuCdeMoQEX3ugInmWUgcKFSRMdlEio=
MIME-Version: 1.0
In-Reply-To: <1282144271.3035.31.camel@mulgrave.site>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
Date: Wed, 18 Aug 2010 18:19:24 +0200
X-Google-Sender-Auth: V0TGCm8K_BZEO3-nIWkV-m5UoDQ
Message-ID: <AANLkTikf2zwVf-9XC_vA8oEMsF6CM0kbqSRjmR=awWbH@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: Bart Van Assche <bvanassche@acm.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chetan Loke <generationgnu@yahoo.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 5:11 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Wed, 2010-08-18 at 07:58 -0700, Chetan Loke wrote:
>> Hello James and others,
>>
>> --- On Tue, 8/17/10, James Bottomley <James.Bottomley@suse.de> wrote:
>>
>> > From: James Bottomley <James.Bottomley@suse.de>
>> > Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
>> > To: "Vladislav Bolkhovitin" <vst@vlnb.net>
>> > Cc: "scst-devel" <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
>> > Date: Tuesday, August 17, 2010, 8:30 PM
>> > On Mon, 2010-08-16 at 20:20 +0400,
>> > Vladislav Bolkhovitin wrote:
>> > > Hello James,
>> > >
>> > > Could you comment rumors that decision about future
>> > Linux SCSI target
>> > > subsystem is done as well as other related rumors:
>> >
>> > If this is related to LSF, the notes on the I/O track are
>> > here:
>> >
>> > http://lwn.net/Articles/400491/
>>
>>
>> During the open panel, my question was really specific -
>>
>> Q) What is the future of a SCSI-target subsystem in linux. Which
>>    target engine/subsystem can we expect?
>>
>> Your answer) There is place for only 1 target-subsystem in the Linux
>> scsi stack and in the LSF summit the decision was taken to merge LIO.
>> Has that
>> decision changed since the summit?
>
> The decision hasn't been taken to merge LIO, but based on what happened
> at the summit, I think it's the most viable candidate and will likely be
> merged by 2.6.37
>
>> As a scst-user what I would like to understand is, what was that
>> decision based on? Because the LSF summit was 'small by invitation'
>> only summit. The notes don't give us an insight on the selection
>> criteria/merits etc.
>
> The notes list 3, what's unclear about it?

Hello James,

Thanks for taking notes during the storage track and sharing these
notes (http://lwn.net/Articles/400589/). These notes are interesting
but do not reveal why LIO is preferred.

Also, the list with the three acceptance criteria is incomplete. A
very important criterion before any kernel code can be merged upstream
is whether or not there is a maintainer for that code. Someone who has
proven prior kernel coding experience and someone who understands the
new code thoroughly.

Bart.
