Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317Ab1J3Rbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:31:53 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:49594 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934273Ab1J3Rbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:31:52 -0400
Subject: Re: [PATCH] [RESEND] media: tea5764: reconcile Kconfig symbol and
 macro
From: Paul Bolle <pebolle@tiscali.nl>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4EAD8832.9090509@xenotime.net>
References: <1319976530.14409.17.camel@x61.thuisdomein>
	 <4EAD7E9F.6050709@xenotime.net> <1319994738.14409.37.camel@x61.thuisdomein>
	 <4EAD8832.9090509@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Oct 2011 18:31:43 +0100
Message-ID: <1319995903.14409.42.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-30 at 10:24 -0700, Randy Dunlap wrote:
> On 10/30/11 10:12, Paul Bolle wrote:
> > 2) I'm not sure why things are done that way. Why can't builtin drivers
> > and loadable drivers default to identical values? But perhaps I'm just
> > misunderstanding the code.
> 
> They could default to identical values.

That would make the cleaning up I'm trying to do now somewhat easier. It
would allow to simplify the drivers a bit too.

> Maybe someone thinks that
> it's more difficult to pass parameters to builtin drivers so they
> just try to use some sane defaults for them instead, whereas it's
> easy (easier) to pass parameters to loadable modules.  ??

Perhaps Mauro or the people at linux-media know the reasoning here. Or
they can show us that I didn't parse the code correctly, of course.


Paul Bolle

