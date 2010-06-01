Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0FAO3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:29:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab0FAO32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MzxPn/e+hPhdHM9s9TMsRjyri5ojqXzhMl8q9oObhdwgFbe564nziA9kP0COPpRQef
         d+uutB4YM6ojKX414hwIfQ/w6WQ/7dJws2KnhqIHT0ukMCxo57vq4OkeQ2bWcLNKgad3
         VRC8eLQ2nTM+4HOv6zm8L+7GuslgPqw99JuSc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: sedat.dilek@gmail.com
Subject: Re: [Regression] [2.6.35-rc1][suspend to ram] BUG: using smp_processor_id() in preemptible [00000000] code: cat/3634
Date: Tue, 1 Jun 2010 16:29:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org
References: <AANLkTimjEegQQxqllHI2jolnAlgg4eAQdsmENeNnwBlT@mail.gmail.com>
In-Reply-To: <AANLkTimjEegQQxqllHI2jolnAlgg4eAQdsmENeNnwBlT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011629.22552.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 1 czerwca 2010 o 00:47:17 Sedat Dilek wrote:
> [ CC cpufreq@vger.kernel.org ]
> 
> [1] directs you to a fix from cpufreq ML.
> It worked fine here on my HP nc6400 notebook.
> 
> - Sedat -
> 
> [1] http://lkml.org/lkml/2010/5/31/77
> 

This patch solves problem. Thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
