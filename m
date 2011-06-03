Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1FCHoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:44:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44172 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1FCHog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gf3FWUCKrLn5Q67N0zh93dlvoCv+eEA0uNpZvkrPcU+vFCvgVj3GZIb3RYj91j6CK4
         KEWH6fLDeOQdvKLUVKTqg70fkGqVUMsrmf6Rv3F/h0MtV+wuznZaKRo5zfMLHW8gZjf8
         VVUlqaWtnA7p4dGWGFxU+s/YfmAN6uetmjxK4=
MIME-Version: 1.0
In-Reply-To: <1307086473.7474.1.camel@phoenix>
References: <1307086473.7474.1.camel@phoenix>
Date: Fri, 3 Jun 2011 09:44:36 +0200
Message-ID: <BANLkTikt4y3ZKJD2Ld_hxAAzjOpevEqFfA@mail.gmail.com>
Subject: Re: [PATCH] mtd: pxa3xx_nand: remove unused variable 'mtd'
From: Daniel Mack <zonque@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-mtd@lists.infradead.org,
        Lei Wen <adrian.wenl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Fri, Jun 3, 2011 at 9:34 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Remove unused variable 'mtd' to eliminate below warning.
>
>  CC      drivers/mtd/nand/pxa3xx_nand.o
> drivers/mtd/nand/pxa3xx_nand.c: In function 'pxa3xx_nand_suspend':
> drivers/mtd/nand/pxa3xx_nand.c:1167: warning: unused variable 'mtd'
> drivers/mtd/nand/pxa3xx_nand.c: In function 'pxa3xx_nand_resume':
> drivers/mtd/nand/pxa3xx_nand.c:1180: warning: unused variable 'mtd'

Do you actually use this driver? I'm asking because there's some sort
of nasty regression in the changes between 2.6.38 and 2.6.39 which
makes the driver fail to work on my PXA300 based board. Lei and me
tried to nail these issues down, but we didn't succeed yet.


Daniel
