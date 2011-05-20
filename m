Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935351Ab1ETFiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:38:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48798 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935329Ab1ETFiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bB780kwok4cFV3BJHRrqMgUSFpc0/6/5bTu26O1iQ8iNPS2JQJXDi6LBij9ahdDbDU
         JOfefSNG2Dps5Zg4C6ChQRj9kAKosL4i7CEgcifEcqpgDIxzXhpZmLXulKh+X3MmxrmW
         hdOG2x1EPz6NpfoPFrUbijYrmFXkxlyvjJY8A=
Subject: Re: [PATCH 1/2] driver:mtd:use the wrapped __get_mtd_device in
 get_mtd_device_nm
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: dwmw2@infradead.org, akpm@linux-foundation.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1305642979-7419-1-git-send-email-wanlong.gao@gmail.com>
References: <1305642979-7419-1-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 08:34:25 +0300
Message-ID: <1305869665.2630.86.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 22:36 +0800, Wanlong Gao wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Use the wrapped function __get_mtd_device in the function
> get_mtd_device_nm instead of these get device reference codes.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>

Pushed this patch to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

