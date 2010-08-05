Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab0HEE6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:58:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45534 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0HEE6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hw1Nt4BZCyyE+CVNY6Jj0X6d1uBcpIjSolDe5ah+LZb9DJ8FjZv7ivxXMh+THFtAB6
         NIOA8nmHBRXL/Rk7fciJi3nqDQOVbvRpi0QO/HHtWYyhTX4YMzX4k/6mh4CeUkRBNCCP
         Cs6Y5fswcpja3Ez4R+Naw5H/GECci9AyBhr4M=
Subject: Re: [PATCH] Change struct flchip_shared spinlock locking into mutex
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1280778048-6208-1-git-send-email-stefani@seibold.net>
References: <1280778048-6208-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 07:58:11 +0300
Message-Id: <1280984291.1175.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 21:40 +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This patch prevent to schedule while atomic by changing the
> flchip_shared spinlock into a mutex. This should be save since no atomic
> path will use this lock.
> 
> This patch is based on linux kernel 2.6.35. Please apply.
> 
> It was requested by Arnd Bergmann and Vasiliy Kulikov.

Taken to my l2-mtd-2.6.git / master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

