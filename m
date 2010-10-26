Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab0JZCKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:10:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45920 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab0JZCKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:10:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xgSypU47eAusaFb7zHBtQJtj9KXSIp6PbIUJUKqlVz5BTedQ37Up1qb5xqeh4mcItD
         +/LUFaVmZrDtV6SXa+GHQ8+lKkGEiInly+DFKDTln8z3wnFQ29RP7pmx3zRWe0bR2vHh
         JH1YPfxlNqBBn1ejGihiUhe+seu+dOA+j4tlo=
Subject: Re: [PATCH 15/29] memstick: jmb38x_ms: Create header
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <555825.15477.qm@web37605.mail.mud.yahoo.com>
References: <555825.15477.qm@web37605.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:10:17 +0200
Message-ID: <1288059017.4024.141.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:56 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 15/29] memstick: jmb38x_ms: Create header
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > In the new header add:
> > 
> > * debug macros
> > * Registers + some documntation
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> 
> Yet again, what's wrong with DYNAMIC_DEBUG?

DYNAMIC_DEBUG:

a) has to be enabled by distro.
b) lacks debug levels.

And it is used unless user sets the debug= argument.
You did read the patch didn't you?


Best regards,
	Maxim Levitsky

