Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab0D3TMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:12:35 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52371 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab0D3TMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:12:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=WSi5d2OrYXqsZX2FpUJatYwfwRqYt31sFSPz4BNZ8ayVd50a2c9ajFA32inq8/OS/4
         c6risk67OLKlCUC6UonTKaJyQvEYfVeP2U0zstEprOXjp/LFAv0ZAYxT4QD0Cxji6o4Z
         GhQHKLjsxqx2BKO0sHzo/yHu5kjU99ozLUEjc=
Date: Thu, 29 Apr 2010 22:59:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the bkl-ioctl tree with the
	bkl-procfs tree
Message-ID: <20100429205944.GC5392@nowhere>
References: <20100429154954.84966e61.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100429154954.84966e61.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 03:49:54PM +1000, Stephen Rothwell wrote:
> Hi Frédéric,
> 
> Today's linux-next merge of the bkl-ioctl tree got a conflict in
> drivers/char/i8k.c between commit
> 64ef834551d7696f54553d7608eba80a5a800e77 ("procfs: Push down the bkl from
> ioctl") from the bkl-procfs tree and commit
> 59ce88717d9d8af8cb14af3a0a505cafb692b482 ("drivers: Push down BKL into
> various drivers") from the bkl-ioctl tree.
> 
> I used the version from the bkl-procfs tree for today.
> 
> Can you guys please sort out these various bkl removal trees, please.


I'll do a test merge of my branches and solve the conflicts I can find.
Sorry about that.

