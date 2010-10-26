Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0JZQqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:46:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56578 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0JZQqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HP8Kv87f/TzUuiPYdELsGcrXrBrSiTAjTeP08deAtRa6BpYX/Ac5cU3ZJig2+fwuyQ
         O/fUoMzefyOhqiPXAZfDsxSxRLSsGGgQi6v9cETOr9iIVZ/gpyAhTwtEhTc+YbiOXKUq
         GWfYy/jW602c9BVAjX6J0bma1BWY1KwMTmmZE=
Subject: Re: [PATCH] sparc32: make CONFIG_SPARC_LEON depends on !SMP to fix
 build failure
From: Namhyung Kim <namhyung@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101026.093213.115933777.davem@davemloft.net>
References: <20101026.085338.104057457.davem@davemloft.net>
	 <1288108960.1717.1.camel@leonhard>
	 <20101026.090428.189722351.davem@davemloft.net>
	 <20101026.093213.115933777.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 01:46:43 +0900
Message-ID: <1288111603.1717.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-26 (화), 09:32 -0700, David Miller:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 26 Oct 2010 09:04:28 -0700 (PDT)
> 
> > From: Namhyung Kim <namhyung@gmail.com>
> > Date: Wed, 27 Oct 2010 01:02:40 +0900
> > 
> >> 2010-10-26 (화), 08:53 -0700, David Miller:
> >>> Great, I'll apply all three of your patches thanks.
> >> 
> >> Thanks. BTW, can you please take a look below too?
> >> 
> >> http://lkml.org/lkml/2010/10/25/13
> > 
> > Sure.
> 
> I've applied this.
> 
> Please CC: sparclinux@vger.kernel.org on such patches next time, so
> that it gets into my patchwork queue and you don't need to ask me
> to go looking around in other places for your patches.
> 
> Thanks.

OK. I accidentally missed that, sorry. And thanks again for your quick
responses and all great works. :-)


-- 
Regards,
Namhyung Kim


