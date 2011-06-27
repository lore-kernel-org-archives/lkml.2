Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1F0FtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 01:49:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51632 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab1F0Fsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 01:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=yBy0MLFXILvCwoJbX/hYPDfRXsjIXfEtN8hRyBGg8rTx1gg9jViEVLe6MUbjOPcLdL
         NRQWLHg860rGSRv+NwYL0ocSdRjNyarv60Y3JUzTTMzgv2V0o90w6M+Te0EJTQzE2GWO
         ZbObpFKHw5YeRoKDzYaQ66S9ok6kC2j/pp+Fc=
Subject: Re: [PATCH 1/2] mtd: make ofpart buildable as a separate module
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-mtd@lists.infradead.org, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Jun 2011 08:49:23 +0300
In-Reply-To: <1309122180-12838-2-git-send-email-dbaryshkov@gmail.com>
References: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
	 <1309122180-12838-2-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309153769.23597.15.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 01:02 +0400, Dmitry Eremin-Solenikov wrote:
> As ofpart now uses a standard mtd partitions parser interface, make it
> buildable as a separate module. Also provide MODULE_DESCRIPTION and
> MODULE_AUTHOR for this module.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Pushed this one to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

