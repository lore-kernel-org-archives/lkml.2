Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0FNCez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 22:34:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab0FNCex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 22:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aA+7CWs2aoQnutxyYzQ1FS3sTOotWhxTqDiWHA2atKncJNVkPfhrtR5fU2/hL6h9TO
         xch2cxUprE3lweUyQfpTwmf0UImouRcPvRe5r+ZQgQtsqvX/lnyMgzeR0aVB5jFrzhER
         2NbQssWS4ly7tlI5D4i7ylteNWxkFqLTgK/nk=
Subject: Re: linux-next: build warning after merge of the ubi tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100614115822.728c3199.sfr@canb.auug.org.au>
References: <20100614115822.728c3199.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 05:34:47 +0300
Message-Id: <1276482887.9881.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 11:58 +1000, Stephen Rothwell wrote:
> Hi Artem,
> 
> After merging the ubi tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/mtd/ubi/io.c: In function 'ubi_io_read':
> drivers/mtd/ubi/io.c:153: warning: initialization makes integer from pointer without a cast
> drivers/mtd/ubi/io.c:170: warning: format '%s' expects type 'char *', but argument 5 has type 'int'
> drivers/mtd/ubi/io.c:177: warning: format '%zd' expects type 'signed size_t', but argument 7 has type 'int'
> drivers/mtd/ubi/io.c:177: warning: too many arguments for format
> 
> Introduced by commit 1a49af2ca019dcb4614c32f832bbcb814b61409c ("UBI:
> improve ECC error message").

Thanks Stephen,

I'll take care of these today.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

