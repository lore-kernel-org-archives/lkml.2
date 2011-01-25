Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1AYKnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:43:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61404 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1AYKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:43:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pE8CQ6IcALtX//lO2E3o/WsHASkx9rRd+aO9bIivVHbja8M2ABOEDOTYYavmq392eX
         PVdVs+D8IWG81nAucLvA1zBZjT/g949+qJ6kar9uh5QGjNwwGlqnVFa8+9XbrKj1Cltm
         o2Q7srHbRajdvRE2h76SSoQf14fqwaw6zAn3s=
Subject: Re: [PATCH] UBI: fix unaligned leb_start value
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: John Ogness <john.ogness@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87zkqu1fuh.fsf@vostro.fn.ogness.net>
References: <87zkqu1fuh.fsf@vostro.fn.ogness.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 12:42:40 +0200
Message-ID: <1295952160.7118.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 15:39 +0100, John Ogness wrote:
> From: John Ogness <john.ogness@linutronix.de>
> 
> The wrong header size was used in calculating the data offset. The
> data offset should be VID header offset + VID header size (aligned to
> the minimum I/O unit).
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

I've tweaked the commit message and pushed this to the UBI tree, thanks:
http://git.infradead.org/ubi-2.6.git/commit/a25376636fa6cee8017a22144652f276840281bf

> ---
> This patch is against linux-next-20110121.
> 
> Since the value is later aligned, this patch does not fix any real
> world problem. But it should be fixed nonetheless.

Not exactly, this does not fix any real problem because UBI_EC_HDR_SIZE
and UBI_VID_HDR_SIZE are currently equivalent :-)

Thank you!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

