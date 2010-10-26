Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0JZCTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:19:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab0JZCTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wzbnhwMFSvQVXn+zW4Dznmp/nLPXRKB7B+fXUmvvNwujygN9eQjiG+bWs/gQ9FGMNW
         +XDsxem2c7vEl5vinvgvR/ORgq5kIYPC/OsWFnL8QFKUKp4lR1YLtnEJTXG+Y64HBo0J
         EAtJOFWHT84ErZr+kkQma8e1GjYMvAKfrq/fo=
Subject: Re: [PATCH 19/29] memstick: jmb38x_ms: add register read/write
 functions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <747229.25358.qm@web37601.mail.mud.yahoo.com>
References: <747229.25358.qm@web37601.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:19:46 +0200
Message-ID: <1288059586.4024.164.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 09:03 -0700, Alex Dubov wrote:
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 19/29] memstick: jmb38x_ms: add register read/write functions
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > All over the code it is a bit easier
> > to see the
> > register access with this patch. Also set/clear mask
> > helpers refactor code a bit, but the biggest reason
> > for this patch is to make it possible to trace register
> > read/writes with a flip of a module param.
> > 
> > Currently these functions are unused, but will be by later
> > code
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> This looks like a case of:
> 1. You've run into a technical difficulty.
> 2. You used some temporary code to resolve and document it.
> 3. Now this temporary code is forever here to stay.
What? What you are accusing me of?
This is just an insult.

Having a simple way to trace register writes is always a good thing.

Also I have very similar code in ene_ir and r852. No complains.

Best regards,
	Maxim Levitsky

