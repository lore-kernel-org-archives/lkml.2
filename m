Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1DEW6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 18:58:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37225 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab1DEW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 18:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BmRjTheaJMn8JSiqY3pt0/YBsMYk3Mv0f5i2db/BEgVlNOW3ui1k1YGJTtrE8rRzPp
         YBOQvgcrZi1Ox+no9p2eM0juI7vrT4SRp2/9ALGWWD4NSu3BvTyHZ0eP1dIIIJ0OQCbY
         POr6NTLBBlYieJdN6Hf7CGBKCKhek/ok4QS4o=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
	<AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
	<201103311704.40372.roucaries.bastien@gmail.com>
	<BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
	<4D9B3C10.9060704@suse.com>
	<BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
Date: Wed, 6 Apr 2011 00:58:40 +0200
Message-ID: <BANLkTi=yTfMiLvVtZTqQvxVhy7aFPdwSXQ@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/5 Bastien ROUCARIES <roucaries.bastien@gmail.com>:
> On Tue, Apr 5, 2011 at 5:58 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 04/05/2011 09:30 AM, Bastien ROUCARIES wrote:
>>> Ping ? You said on bugzilla it is related to acl but see nothing
>>
>> Yeah, I think it's related to the nesting not being quite right, but I
>> need to look into it more. I've been unable to reproduce the problem
>> locally.
>
> You could reproduce quite easilly using with a lot of git pull in
> parallel (in a lot of different repo)... In less than one hours if you
> have luck
>
> Bastien

Ah. I'm going to try that.
Can you perhaps send us your .config, in case it happens only on some
specific set. And also your options passed to mount reiserfs in /etc/fstab ?

Thanks.
