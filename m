Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab0JZCBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:01:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39049 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0JZCBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:01:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EN3ZQAlKLDeyeRLb2PmYluYOVFhZMPR0UkU6I3MlcNa14KJvG17Ca2jDAvK5ktS0JP
         ySLoWEsQXDAx27lLYwIH2jgY2Kme4grOaMniUIt6FeDwojAP7wuBEUXDT61LesoWRp1S
         UdC3gwlvDP5kaPfpbKgkp8fL2Zc9SUCksZ6e4=
Subject: Re: [PATCH 12/29] memstick: mspro: rework interface switch
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <596336.88845.qm@web37607.mail.mud.yahoo.com>
References: <596336.88845.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:01:18 +0200
Message-ID: <1288058478.4024.124.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:28 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 12/29] memstick: mspro: rework interface switch
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > Now no old style state machine
> > exist.
> > Thus this patch removes now unused code.
> > 
> 
> This patch does somewhat more, than just removing the dead code.
> Description/rationale?

I will update the patch description.

Best regards,
	Maxim Levitsky

