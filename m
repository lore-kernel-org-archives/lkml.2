Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0F2HRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:17:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34247 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0F2HRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kwnsDIh9pPFx3ZvlYRB449JT/sJVxZ+Wz/p8if9+74uzi05wC+cc+jUaSUiEU6pg7L
         sBERvi9HT2391/wQOzObGAdzbuGaoxWIh/RrmKYtEX4CFerxEAtgDp2MyLBbFmnEkfiI
         MUApv9i5yfvjK2EHGO+ulkqg5pL4tNAja0qg0=
MIME-Version: 1.0
In-Reply-To: <4C29420D.2010406@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C29420D.2010406@intel.com>
Date: Tue, 29 Jun 2010 00:17:32 -0700
X-Google-Sender-Auth: MfYFdkXyQNghM-2xRhNSed7Uli0
Message-ID: <AANLkTinwk8OF7I9QJxFrmSvCvgT5ha_tSzc5dl_ODt6Z@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 5:45 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Looks like that dev_err() did not make it to the console.  The attached
> patch should get us some more debug information.  This will stop the driver
> from making forward progress (applies to current -git).  I suspect this may
> be triggering from the driver self test, but to be safe you should set
> CONFIG_NET_DMA=n and CONFIG_ASYNC_TX_DMA=n.

I will try that tomorrow and get back to you.

Chris
