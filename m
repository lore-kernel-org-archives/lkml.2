Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0JZByd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:54:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62494 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab0JZByc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CMtcfcHOmrwV7mZe/VK2T70/UJUUbwkXA7bjHGxodV0p2oI6vOYzQ2KlfMAjDT2Zmf
         U1B+BzTROMXgP4U3GNGM9qUv+HcjimSHYhL00Yi0EnCe95AQBJaBT8uj2cvvuJDOnBXX
         AX2dVkZjhxnw8woxr/oiJBKwgHzFejHir1Gas=
Subject: Re: [PATCH 08/29] memstick: mspro: add comments to few functions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <479817.96049.qm@web37606.mail.mud.yahoo.com>
References: <479817.96049.qm@web37606.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:54:26 +0200
Message-ID: <1288058066.4024.108.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:18 -0700, Alex Dubov wrote:
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 08/29] memstick: mspro: add comments to few functions
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > a comment before function is not only
> > a good way
> > to give some information to the reader, but
> > it serves as a good anchor point for diff so that
> > it doesn't produce a diff between different
> > functions (sigh...)
> > 
> 
> Comments of new functions belong to the patch which introduces these new
> functions. And those functions (as I already said) belong to the patch
> which introduces new functionality, using these functions, desirably,
> one function at a time.
You did read the patch didn't you?
I added few comments to _existing_ functions something that code really
needs.
I also did explain why did I do that here, didn't I?
It makes next patch cleaner, as diff doesn't attempt to create a diff
between different functions.


-- 
Best regards,
        Maxim Levitsky

