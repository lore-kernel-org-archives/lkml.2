Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0CQWXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:23:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:4069 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab0CQWXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LbAh2tM7p4RXA919hxLEJaMVysqynIwgZxIRm0DalY6bfI+VYglyBuEHLr7uPsLSk8
         niNkiCLuv9FOgoGWFvd0Fghaa5bSnomG2guYyAC7zBTlLWC26keJoFe1DIb16nluksw8
         VBkZSnXGGvZLiKtsr66HAfcugKfTO/2FVGeCE=
MIME-Version: 1.0
In-Reply-To: <20100317200431.GA24631@havoc.gtf.org>
References: <20100317200431.GA24631@havoc.gtf.org>
Date: Wed, 17 Mar 2010 18:22:59 -0400
Message-ID: <6041d2001003171522u616c319eocc850c66acae49c7@mail.gmail.com>
Subject: Re: [git patches] libata fixes
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 4:04 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> The ATA timeout bug is still being worked, testers welcome.  Patch posted
> to linux-ide and LKML was also posted to the tracking bug,
> http://bugzilla.kernel.org/show_bug.cgi?id=15537

Since you're asking for testers, that patch does fix the ATA timeout
issue for me - it was easy to trigger when doing a kernel compile when
in IDE mode.

I do still see a few "clearing spurious IRQ" messages that are new
with 2.6.34, but with no visible effect.

Marc
