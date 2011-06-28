Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1F1IAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:00:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61603 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab1F1H6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GQzosYyqdX44O5PUgs8qloCQP0Js+5FHPbvxLTrqPerf6NXn1e+U4xSb33uo7VtvIr
         UewPqZgIDIJyY3z/ZKC2IAonQ2DeI/S8yvKQe379KImVI8dHnghboiyIyqBYJc0QxHsj
         I0KhQ9BSg4YmlJNdolugMID227+sKsnRJVLb0=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
Date: Tue, 28 Jun 2011 09:58:23 +0200
Message-ID: <BANLkTin_axWbYNKox+R59VmEq7tggaKvHQ@mail.gmail.com>
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully last thing ;)

2011/6/26 Geert Uytterhoeven <geert@linux-m68k.org>:
> m68k allmodconfig:
>
> drivers/bcma/main.c: In function ‘bcma_release_core_dev’:
> drivers/bcma/main.c:68: error: implicit declaration of function ‘kfree’
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> --


If this is not manual mistake, you may want to fix your script or
whatever you use. You typed "--" instead of "---", which resulted in
the following commit message:



m68k allmodconfig:

 drivers/bcma/main.c: In function âbcma_release_core_devâ:
 drivers/bcma/main.c:68: error: implicit declaration of function âkfreeâ

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
 --
 http://kisskb.ellerman.id.au/kisskb/buildresult/4243344/

  drivers/bcma/main.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)
Signed-off-by: John W. Linville <linville@tuxdriver.com>



-- 
Rafał
