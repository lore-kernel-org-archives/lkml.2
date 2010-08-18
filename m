Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0HRRvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:51:12 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51575 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0HRRvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GDUv9gcUIHt5V3T4l1NAfcBrHvPJ+4lahg34k1CQoaYLUHKYcnXBXoth/QW+1WeVux
         9srX/KdQQD2yjI+/uar92DKWlkn8JnI+kHVdBpUWILC8iPjH1uhpM8qV4NFO0nKWuveF
         RjZNSigi4f5al4X9EvGa5oCG4YrBuh5HfcXKM=
MIME-Version: 1.0
In-Reply-To: <1282148296.3035.49.camel@mulgrave.site>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
	<AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	<1282148296.3035.49.camel@mulgrave.site>
Date: Wed, 18 Aug 2010 13:51:07 -0400
Message-ID: <AANLkTimYZOyRv8u8bqNPRMseBcboSuJAWjtwo5MQCSQR@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: Chetan Loke <chetanloke@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chetan Loke <generationgnu@yahoo.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 12:18 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Wed, 2010-08-18 at 12:04 -0400, Chetan Loke wrote:
>> On Wed, Aug 18, 2010 at 11:11 AM, James Bottomley
>> <James.Bottomley@suse.de> wrote:
>> > The decision hasn't been taken to merge LIO, but based on what happened
>> > at the summit, I think it's the most viable candidate and will likely be
>> > merged by 2.6.37
>> >
>>
>> During the open panel, facebook guys and others were tooting that
>> start-ups thrive because they can hack linux. Well there are quite a
>> few start-ups that use scst too for creating target appliances.
>> Has anyone even bothered to glance the scst mailing list to see if
>> that community is dead or alive?
>>
>> I for one use scst to create synthetic work-loads and test 200+ VM
>> nodes in an ESX cluster. Anyone who has worked on a SAN OS will
>> appreciate the simplicity of SCST. And if folks still can't understand
>> the SCST code(after reading the README) then they are still welcome to
>> send an email on SCST. Would you like to make your FC stack go faster,
>> well please drop us an email on SCST and we will try our best to
>> further optimize the FC driver.
>>
>> I know folks who don't understand simple DMA bus traces, FC wire
>> traces and yet they have the power to influence decisions.
>>
>> James you are an expert but not everyone is. This is not a venting
>> session but even folks who are new to target architecture find it easy
>> to hack SCST.
>


> But that's not really relevant, is it?  I would expect that whatever I
> do, even keeping both out of tree, the communities around the solutions
> would still exist and be vibrant, since they're out of tree now, nothing
> will have changed.
>

Of course it's relevant. Not all engineers know about everything when
they venture in a new area. SCST overcomes that. It's not
intimidating. Infact, 3 months back, I asked a storport/miniport(aka
Windows) guy to take a look at scst and after studying the README he
was amazed to see how easy it was. Plus,everyone knows that if a
solution is inbox then it's just easier to maintain. Also no need to
patch/re-spin my iso. And you are missing the point - find me one good
technical conversation thread on LIO! What does that tell you? Why not
give a chance(or atleast consider?) to someone who has a wide/active
user base?

LIO never struggled to push their code upstream and it still is a
viable candidate? On the other hand scst users/developers are ready to
bend over to accommodate all the changes! What does that tell you?

James, how can a community remain vibrant when one solution is
favoured over another w/o any clear explanation and justification?
It's like the old saying - the lips are moving but all I hear is blah
blah blah. We look up to you but why should we accept the outcome of a
closed door LSF session ;)?


> James
-- cloke
