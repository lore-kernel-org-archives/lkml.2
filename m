Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1F0FpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 01:45:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab1F0Fox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 01:44:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=LbLQ6UTQoH2jcbzKFM5263u+8Z37R+HHxNNUwJYedUV3pY+ODODwY+iVWhoFdxu/i+
         oVzxDHjkMzZUXgQlBaGhiWaALZSkuuahsNedJJwPDJ2zIDAuYd190bBIq/87rNMBkOUO
         IoY6pFOk6+Gs9AkanrCc4XbwhZ6S1h1FKCvUQ=
Subject: Re: [PATCH 2/2] mtd/ofpart: add ofoldpart alias
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-mtd@lists.infradead.org, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Jun 2011 08:45:40 +0300
In-Reply-To: <1309122180-12838-3-git-send-email-dbaryshkov@gmail.com>
References: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
	 <1309122180-12838-3-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309153545.23597.13.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 01:03 +0400, Dmitry Eremin-Solenikov wrote:
> ofpart.ko also provides ofoldpart MTD parser. Add respective
> MODULE_ALIAS("ofoldpart"); declaration.
> 

Why we need the alias?

-- 
Best Regards,
Artem Bityutskiy

