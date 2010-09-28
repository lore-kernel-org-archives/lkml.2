Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0I1GbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:31:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60583 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0I1GbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FCzopVCezz25zO6IGvXOgoJ1MaJgt+a7VzXia+FOneo9+5fDruPW5ykX0pnqVVhh2Z
         gg0Egj3a6ptvoKVdPgfLsfpFuyIP/AZy1mT7PivWVwfWXWO09XkNfwryZjqtGNsiu++n
         RjMb4UvO/pnMXG1/FDDN1QmVrse8Eh0nijRdc=
Subject: Re: [PATCH] mtd : add init_size hook for NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: David.Woodhouse@intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <AANLkTi=6zROsDs2zkCJOXJdiPDh53A=x7WXGZKTyHDoO@mail.gmail.com>
References: <1285328063-7982-1-git-send-email-shijie8@gmail.com>
	 <1285502719.13050.17.camel@brekeke>
	 <AANLkTi=6zROsDs2zkCJOXJdiPDh53A=x7WXGZKTyHDoO@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:29:14 +0300
Message-ID: <1285655354.2437.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 11:06 +0800, Huang Shijie wrote:
> Hi Artem:
>     I think the new patch is better.
> 
> The new patch will reuse the id_data.
> Even if the additional id byte does not have all the information in
> some case, but other infomation such as manufacture id and device id
> are also useful to the NAND driver.

OK, pushed this one to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

