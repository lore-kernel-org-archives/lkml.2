Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0DVWFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:05:21 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:50198 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab0DVWFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rgjTNc+2aoT4dR417pZhYwOYVzSbymCPFCHjBTG2hrG1b2aoZHZZkJIMG3LQfBn7U/
         lbUO5WagP3pl01DEzoDFGscYoMuNN5A0X49PWcK/lhXU/tuUzhXq6gf7dwgiH4PawF4S
         +6j3osCghIjcmngkJqSxY7csyGf+8UcrL20vg=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1004222357150.7579@pobox.suse.cz>
References: <1271970765-11856-1-git-send-email-fgaliegue@gmail.com>
	 <p2v8bd0f97a1004221421x4bf0850fm1b47f4838c344368@mail.gmail.com>
	 <y2lac542ca01004221444le9b33c8as587d3382ab7ff0a9@mail.gmail.com>
	 <alpine.LNX.2.00.1004222357150.7579@pobox.suse.cz>
Date: Fri, 23 Apr 2010 00:05:11 +0200
Message-ID: <h2wac542ca01004221505i825a68dendd4fd54bfffe6ac6@mail.gmail.com>
Subject: Re: Should I really bother all maintainers with this?
From: Francis Galiegue <fgaliegue@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 11:57 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 22 Apr 2010, Francis Galiegue wrote:
>
>> >> This patch only fixes quite a common mistake in Documentation/, and if I
>> >> scripts/get_maintainer.pl on the patch (which is recommended), I potentially
>> >> mail thousands of people who probably have more useful/exciting stuff to do
>> >> anyway. So, I submit it as is.
>> >
>> > this kind of stuff usually goes through the trivial tree.  look at
>> > TRIVIAL PATCHES in the MAINTAINERS file.
>> > -mike
>> >
>>
>> Point taken... But the patch doesn't apply as is over trivial/master or
>> trivial/for-next, as two files don't seem to exist on either branch (trivial
>> being the git repository mentioned in MAINTAINERS):
>> Documentation/DMA-API-HOWTO.txt and Documentation/filesystems/ceph.txt.
>
> That's not a problem, I pull Linus' tree into my tree when needed. Just
> resend the patch (based on Linus' tree) to trivial@kernel.org and I'll
> process it appropriately.
>

Ah well, I forgot to mention that this patch was done over Linus' tree
(specifically, commit c81eddb0e3728661d1585fbc564449c94165cc36).

I'll resend right back with Cc: <trivial@kernel.org>.

> Thanks,
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>

-- 
Francis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (Stéphane Faroult, in "The
Art of SQL", ISBN 0-596-00894-5)
