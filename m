Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0KZPiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:38:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51637 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0KZPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:38:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r6kbwSYApCMZ7bftGztMxFnUJocFOD6tbRM9R+vUu/S7TxTiyWmXioPIxEH+GDyKJ/
         um5tfPAQWxPievPDPxJCM8DdnWqQ3FgyCPIHFlfZx7wsh+Gku1PlfXD+dmxbdFNppuYm
         3Hkh5b+I/9KuVpTYrLoSxCN9j1mLS+s2IbvjI=
Subject: Re: [PATCH] mtd: mtdchar: fix information leak to userland
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1289054485-18190-1-git-send-email-segooon@gmail.com>
References: <1289054485-18190-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 17:37:30 +0200
Message-ID: <1290785850.2552.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-06 at 17:41 +0300, Vasiliy Kulikov wrote:
> Structure mtd_info_user is copied to userland with padding byted
> between "type" and "flags" fields uninitialized.  It leads to leaking
> of contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

