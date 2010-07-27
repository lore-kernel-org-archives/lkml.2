Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0G0IKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:10:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50747 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0G0IKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DFZOyzIecuByVPC0eOj/m1jWG9q+qiYLe+KF7mlE3queMDOayS3+lwg+qcCbSYu8Ve
         s/AsJYIL+QaFiL9G6OQpaeMhBCjnmzGrjLPA3ZJQFe33ccbXa6TKSmainEEZxZr8tRdu
         /mgmNbLHv6ZqaRnvLNdyWxhUBlHXh/lo2cvgs=
MIME-Version: 1.0
In-Reply-To: <20100727150138.2F20.A69D9226@jp.fujitsu.com>
References: <20100727134431.2F11.A69D9226@jp.fujitsu.com> <AANLkTimdLbwvRNU09s+LfauREBaxyXBUE5jSmwnpCj8e@mail.gmail.com> 
	<20100727150138.2F20.A69D9226@jp.fujitsu.com>
From: dave b <db.pub.mail@gmail.com>
Date: Tue, 27 Jul 2010 18:09:41 +1000
Message-ID: <AANLkTikjJ0giM+MpzNu3e0NQN=JLMviPT8UPHdZqGGpz@mail.gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 July 2010 16:09, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Do you mean the issue will be gone if disabling intel graphics?
>> It may be a general issue or it could just be specific :)
>
> Hmm.. I'm puzzled 8-)
>
> I don't understand why other all people can't reproduce your issue
> even though your reproduce program is very simple.
>
> So, I'm guessing there is hidden reproduce condition. but I have no
> idea to find it.

I will try with the latest ubuntu and report how that goes (that will
be using fairly new xorg etc.) it is likely to be hidden issue just
with the intel graphics driver. However, my concern is that it isn't -
and it is about how shared graphics memory is handled :)
