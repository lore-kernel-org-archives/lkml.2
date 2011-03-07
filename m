Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1CGIuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:50:04 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53483 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1CGIuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:50:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JzMrCZ/90fu8lukucgHEN0NmiRDW++9oO14uFl9lZ0v6CWmjmxcR8Of7nxlj3KzZWG
         kwCsxEeGawvCznVPQhHsZzAYQ084nnp4X/0NAW2qn0snCtBcDwMDZUlV/piHI+3uGGKK
         0gypKmmQlq7bMSVGt4bgLV7ZnbyR96cJ1EKRk=
Subject: Re: [PATCH v2 1/1] omap3: nand: report corrected ecc errors
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: John Ogness <john.ogness@linutronix.de>
Cc: linux-omap@vger.kernel.org, s-ghorai@ti.com,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87y650pdc1.fsf_-_@vostro.fn.ogness.net>
References: <87oc64qr5b.fsf@vostro.fn.ogness.net>
	 <1298631549.2798.56.camel@localhost>
	 <87y650pdc1.fsf_-_@vostro.fn.ogness.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 10:48:35 +0200
Message-ID: <1299487715.2746.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 13:12 +0100, John Ogness wrote:
> From: John Ogness <john.ogness@linutronix.de>
> 
> The number of corrected ECC errors should be reported since other MTD
> systems make use of this information (such as UBI data scrubbing).
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>
> ---
> Patch v2:
> o Patch against linux-next-20110225.
> o Added comments explaining return codes.

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

