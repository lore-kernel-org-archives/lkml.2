Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab0JZCWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:22:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42741 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab0JZCWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wFfElgPlR2jC+HEzroJv/NQWyf9oGCil2kTI9y3JZjuMO46hFMO6yLKs6Xmi4vrkta
         OCGdT5lKcd+8VSum81jg73t8cTYmjDOiKUp1RmRk0QW8kQLd3EuY9k7Ib7ljurWe1KBi
         7E1W1eBQo3y/Ywe6QwfGwEXH7aBEVM3KoXW78=
Subject: Re: [PATCH 21/29] memstick: jmb38x_ms: rework TPC execution
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87141.68777.qm@web37608.mail.mud.yahoo.com>
References: <87141.68777.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:22:32 +0200
Message-ID: <1288059752.4024.170.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 09:08 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 21/29] memstick: jmb38x_ms: rework TPC execution
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > Code rewritten to make it simplier.
> > A lot of debug output is added to help
> > diagnose bugs.
> > 
> > No major functional changes
> > 
> > Signed-off-by: Maxim Levitsky<maximlevitsky@gmail.com>
> 
> Was not broken beforehand.

Yet is was.
Best regards,
	Maxim Levitsky

