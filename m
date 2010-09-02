Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0IBK7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:59:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48334 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0IBK7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qSHnSoFzWGO7LLckSwwNcrH6hc2OnUBvbJgKRAh2JlUGObMBmDypAcf1lIs5IUE2+9
         HknEll0SzpXBxJl6D8BoeWYT3m8QK+4PPIR2VbDZJMa1GUzGKo4Olx9dFYMyyfrL5Yac
         7LFDnGrtsRvpDXP3PMXZ8oe/qV4Wuso5iW9/w=
Subject: Re: [RFC] jffs2: use cond_resched() instead of yield()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Ingo Molnar <mingo@elte.hu>, Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <OF213EDC22.80E0A084-ONC1257792.0025CB36-C1257792.00268F36@transmode.se>
References: <1283357021-16187-1-git-send-email-w.sang@pengutronix.de>
	 <1283366151.2209.21.camel@brekeke>
	 <OF213EDC22.80E0A084-ONC1257792.0025CB36-C1257792.00268F36@transmode.se>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 13:59:09 +0300
Message-ID: <1283425149.3085.6.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 09:01 +0200, Joakim Tjernlund wrote:
> At the time cond_resched() was a problem but now I don't know. The erasing
> has moved to the GC thread and been somewhat reworked. I don't know if
> it still needs yield(). Perhaps David can tell?

I think 'yield()' is rather a hack than a real solution.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

