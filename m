Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0HXKqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:46:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38693 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab0HXKqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P9uYaPBJY0hNxra1RftQDLdrbnzlvzeo4s25/aefh9p5QVSyc8oBj1AzfilfgeVms8
         L8aJcvbr8yKJWA14jQkjsyZtLlzOJcq5tlb9pODxZekg4p3apWXnZiozxKCzqmh1DHmn
         5LtZm+E1LtbiOwPO/gKuiwvXub6AYEk4vnvqs=
Subject: Re: [PATCH v2 0/2] Deprecate ECCGETLAYOUT
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <norris@broadcom.com>
Cc: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Sneha Narnakaje <nsnehaprabha@ti.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C6E9C23.6060703@broadcom.com>
References: <4C5CA4A1.1040000@broadcom.com>
	 <1282154806-9420-1-git-send-email-norris@broadcom.com>
	 <4C6DD170.1060807@renesas.com>  <4C6E9C23.6060703@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 13:45:03 +0300
Message-ID: <1282646703.24044.162.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 08:15 -0700, Brian Norris wrote:
> So this leaves the important patch set as the following two independent, 
> slightly different approaches to the same problem; we should choose 
> between them:
> [PATCH v3 1/2] mtd: Expand...
> [PATCH v2 2/2] mtd: nand: Expand...

Could you please re-send up-to date (against current mtd-2.6.git tree)
patches which implement your strategy #2? I'd add them to my l2 tree.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

