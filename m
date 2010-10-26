Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0JZCVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:21:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35926 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab0JZCVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=isgHollf/k62jYKfbUDASNWPL7HA4U0Eb9ocENBQHQpNMyqPOQqYlqt5kLRYd5h3m1
         ebeSTXu/celpE9qFMhDVMX/cWyQdYxhW9S7VM91h29n7rfmhAkQabEv4MilQpEBqIiJr
         8kVm9i61MSd/ZI1suu1LRrpYn2Kf5ZSzKHHjE=
Subject: Re: [PATCH 20/29] memstick: jmb38x_ms: rework PIO
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <728583.65798.qm@web37608.mail.mud.yahoo.com>
References: <728583.65798.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:21:40 +0200
Message-ID: <1288059700.4024.169.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 09:05 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 20/29] memstick: jmb38x_ms: rework PIO
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > Rewrite PIO code to be just simplier
> > and shorter,
> > and comment not so obivous parts.
> > 
> > Signed-off-by: Maxim Levitsky<maximlevitsky@gmail.com>
> > ---
> 
> Yet, you are fixing something that was not broken before.

A code that is hard to read is broken even if it works, because its very
easy for anyone to break it accidentally.
Anybody disagree (except you)?

Best regards,
	Maxim Levitsky

