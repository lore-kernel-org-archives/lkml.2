Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0GRQyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 12:54:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48768 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab0GRQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 12:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OALJ818eV69LiRNaeP5xD2QJycy8XC7fJf22PyddaPCnfL4JcpXJsVg4K1ObWV2DNF
         kN3AE7OmpxkFloBt0kzFVp1Lm8PpZU1BrNghBpzBqgfDS9vkP2FdCRGtJ8qT8FV6hwiG
         7Jb4K5Wjzu01Menh+JtGmpWr3Q+ouvyMOOmUI=
Subject: Re: [PATCH v3] MTD: Nand: Add JZ4740 NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1279368929-21193-1-git-send-email-lars@metafoo.de>
References: <1276924111-11158-18-git-send-email-lars@metafoo.de>
	 <1279368929-21193-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Jul 2010 19:54:08 +0300
Message-Id: <1279472048.16247.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-17 at 14:15 +0200, Lars-Peter Clausen wrote:
> This patch adds support for the NAND controller on JZ4740 SoCs.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org
> 

Do you expect this patch to go in via the MTD tree? I guess it might be
better if it was MIPS tree?
-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

