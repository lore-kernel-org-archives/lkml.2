Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab0JZCRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:17:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48634 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0JZCRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pBgy8achVIyMqnH9QMW76nn2JaNLNy+gmWYj46y3+jeE6yDfZ6eign/XDTcmgJRgiA
         o4uVk6Be8Z8OIh4laf4r+vP7kffzshRA0l3OcxSUP4uMlbkk/nBD5TCY0BF9vx8KssTd
         d6KgwxOELv6T9qrzIoMrl8SH26r24oF2nTJDg=
Subject: Re: [PATCH 18/29] memstick: jmb38x_ms: rename functions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <896945.97413.qm@web37607.mail.mud.yahoo.com>
References: <896945.97413.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:17:11 +0200
Message-ID: <1288059431.4024.158.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 09:00 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 18/29] memstick: jmb38x_ms: rename functions
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > Give functions names that I hope will
> > describe them better.
> > Its a matter of personal taste somewhat, I admit.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> 
> Just like 2/3 of your patches in this pack, until now.
And about 90% of patches that go to kernel no?

Besides again, that was done to minimize diff, and I made _pio postfixes
to make clear that functions are used for PIO.



Best regards,
	Maxim Levitsky

