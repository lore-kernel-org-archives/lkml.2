Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab0JZBvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:51:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38980 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0JZBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jymsbWCZOzCqwi/RvQZK7SG4NFbVjniHIwpH287KuUgKXewXjDcFFf6yuuRX2M/WJo
         qv1ntZy9syMPyh755klR2RWf8o+NUTnVfI3cltyXO6bOlATilZfqgJMgyZ+2ZaU8QuvZ
         QwIDduMvzelWYE14+AwS2rlBrxnsLYCq6GlwM=
Subject: Re: [PATCH 07/29] memstick: mspro: two fixes
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <915551.30341.qm@web37604.mail.mud.yahoo.com>
References: <915551.30341.qm@web37604.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:51:45 +0200
Message-ID: <1288057905.4024.103.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:13 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 07/29] memstick: mspro: two fixes
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > fix uninitialized spinlock warning on
> > resume
> > and race in idr_pre_get
> > 
> 
> I fully agree.
> 
> Coding style!
Passed checkpatch.pl.

-- 
Best regards,
        Maxim Levitsky

