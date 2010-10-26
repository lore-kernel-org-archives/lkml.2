Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0JZB57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:57:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59947 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0JZB56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UUQn1sDsZVj8nJzFvZ4tPBaj+eJN0XqBDkwqA1g56YTLWmtrRs7UgzTIjuMqFD9tI2
         q1TdQlc3eYoz7HdXj1/jwdNUBLVAIdqKgDtHEthqm87lWgKWdR11/KVMyH9YntLHOsqE
         HaCsqUfC5uM3pk3R5/67kECy9FnEI/oJeSf64=
Subject: Re: [PATCH 09/29] memstick: rework state machines + attribute read
 function
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <88857.15062.qm@web37602.mail.mud.yahoo.com>
References: <88857.15062.qm@web37602.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:57:53 +0200
Message-ID: <1288058273.4024.116.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:23 -0700, Alex Dubov wrote:
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 09/29] memstick: rework state machines + attribute read function
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > Code is rewritten to use new style of
> > state machines.
> 
> As I said before:
> 1. Rationale for this "new style".
OK, will explain in patch description better.


> 2. Human readable names for states and state transitions.
Don't want to do, I explained why.


> 3. Coding style.
passed checkpatch.pl



> 
> 
> > Attribute read function is cleaned up and commented
> > sparsely.
> > 
> 
> Belongs to separate patch. Attribute read function is quite isolated from
> everything else.
Its not.
Your old attribute read function plays games with param register,
so I will need to change it first to use global param register, and then
port it. I hate doing that. If you insist, ok.



-- 
Best regards,
        Maxim Levitsky

