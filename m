Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1FFKpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:45:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47772 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1FFKpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:45:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JNYVaxh+knyylNKoyVHI4iBjXaAMPBVGyZlxrYcUFZGoXHGYnqCS+1c/saFtzJo4ld
         sbG7OmD48x6h9+dRZa4cM0REPZQrdapjyaHEgDD/hJvT/fSaw2i9UZUO39esLI3B47vL
         Fi9+EHJiNWzMjbZY5VggKgxLGG04e0mjICXuQ=
Subject: Re: [PATCH] MTD: pxa3xx_nand: Fix blank page ECC mismatch
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Daniel Mack <zonque@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Lei Wen <leiwen@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        stable@kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <BANLkTik1_cuo5UH995agoNYa2FdQ8Qasiw@mail.gmail.com>
References: <1307106198-11965-1-git-send-email-zonque@gmail.com>
	 <BANLkTimpLKkfSJbeuM6kc7bUE+JybTmVrA@mail.gmail.com>
	 <BANLkTik1_cuo5UH995agoNYa2FdQ8Qasiw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 13:40:49 +0300
Message-ID: <1307356849.3112.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 23:31 +0800, Lei Wen wrote:
> Also cc to MTD mailist
> Cc: linux-mtd@lists.infradead.org

Please, re-send non-quoted patch.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

