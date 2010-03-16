Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937590Ab0CPJLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:11:15 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33241 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662Ab0CPJLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=E3fIQrspKRoYbTQQDycw5roMW/ZqD4ABJFVBRo1KnLIXXXiF6cb8ku7CM/UQvCUV1b
         zGMYco46Cx7W9q/JKwoYoIOsJ8MHuvFmGwC9oToYl2h3g6UfcPmQrVoU8VErDBJgLuim
         D5ejtSS+yA5CFJj13TcOAv1b6lLRBJG8yxHmg=
MIME-Version: 1.0
In-Reply-To: <b6fcc0a1003160132m62b2b2a1x28dbe6b99e74abf5@mail.gmail.com>
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org>
	 <20100316061718.GA22651@elte.hu> <4B9F2B0A.70507@kernel.org>
	 <4B9F36C7.4020304@kernel.org> <20100316075726.GE18448@elte.hu>
	 <b6fcc0a1003160132m62b2b2a1x28dbe6b99e74abf5@mail.gmail.com>
Date: Tue, 16 Mar 2010 11:11:12 +0200
X-Google-Sender-Auth: 61b3168c42fdb4ee
Message-ID: <84144f021003160211tde2c641j478da44bdb8efe9c@mail.gmail.com>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 10:32 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> It's amazing to see how much sidework people are willing to create
> to _not_ do simple and obvious thing -- just remove slab.h.

I'm not following your idea here. Where do you propose moving
kmalloc() and friends to? kernel.h?
