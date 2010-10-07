Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab0JGGad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 02:30:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53391
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131Ab0JGGab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 02:30:31 -0400
Date: Wed, 06 Oct 2010 23:30:52 -0700 (PDT)
Message-Id: <20101006.233052.233715980.davem@davemloft.net>
To: error27@gmail.com
Cc: mac@melware.de, isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] eicon: make buffer larger
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101004192459.GE5692@bicker>
References: <20101004192459.GE5692@bicker>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Mon, 4 Oct 2010 21:24:59 +0200

> In diva_mnt_add_xdi_adapter() we do this:
>   strcpy (clients[id].drvName,     tmp);
>   strcpy (clients[id].Dbg.drvName, tmp);
> 
> The "clients[id].drvName" is a 128 character buffer and
> "clients[id].Dbg.drvName" was originally a 16 character buffer but I've
> changed it to 128 as well.  We don't actually use 128 characters but we
> do use more than 16.
> 
> I've also changed the size of "tmp" to 128 characters instead of 256.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied.
