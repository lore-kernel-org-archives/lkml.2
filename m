Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0JZB6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:58:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43709 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0JZB6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ooxYgYNot1AdWEeInwlIa+RjlGlWg9n1qAp+N+VJX97IhjGYmYg/8ibytEOnwNirhx
         /FC++ypRuLTiyESAmiHSJZZOHnGak5r4pt8VlID3zIhnHliiznbAqBvZJMgzKtR1v2Pc
         KjuvgUUG3hkjkEpFsFLeSPIk0JR7FmLZa9MeI=
Subject: Re: [PATCH 10/29] memstick: mspro: create _setup_io helper.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <896041.423.qm@web37601.mail.mud.yahoo.com>
References: <896041.423.qm@web37601.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:58:47 +0200
Message-ID: <1288058327.4024.119.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:25 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 10/29] memstick: mspro: create _setup_io helper.
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > This function contains common parts
> > of IO setup
> > for the state machine, thus reduces the risk
> > of using the state machine in wrong way.
> > 
> 
> 1. This should precede the read_attribute function patch.
Why?

> 2. Coding style. 
checkpatch.pl passed.


-- 
Best regards,
        Maxim Levitsky

