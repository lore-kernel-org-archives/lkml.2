Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab0GPWkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:40:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39671 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0GPWkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JlJhfXyrZq0KDTxq4fVY5oW+r0pc6QETGd5mHIjQPYriis8D0nt2whszC4syaY53xI
         I1lTiNplPcG2pY9DY+/74tC1u89CIfQCYhYXBPwIPg025Qx5qBnmuTDUV/ZimIzGAu6l
         kRnLiD6tBdw99CaxXa/w+if1TjFvTYtl8fdoU=
MIME-Version: 1.0
In-Reply-To: <1279318325.27733.21.camel@macbook.infradead.org>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C2AC55E.3040303@intel.com>
	<AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	<1277923422.16256.8.camel@localhost>
	<4C2B9DAC.1030806@intel.com>
	<1277928125.18854.0.camel@localhost>
	<4C2BBACF.3080405@intel.com>
	<1277965264.18854.16.camel@localhost>
	<4C2C3B07.7050200@intel.com>
	<1277968336.4945.3.camel@localhost>
	<4C2C4319.6090906@intel.com>
	<1277972137.12558.2.camel@localhost>
	<4C2CCE67.6070600@intel.com>
	<AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
	<AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
	<1278324973.16975.68.camel@localhost>
	<AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
	<1278463901.20082.34.camel@dwillia2-linux>
	<1278474039.31393.8.camel@localhost>
	<4C34BDCD.9080607@intel.com>
	<AANLkTild7PCKygpPAJRo2G237CY8wJyveM9_Glx8qmoK@mail.gmail.com>
	<4C379462.1020704@intel.com>
	<1278720554.9522.18.camel@localhost>
	<4C3E9F6E.1030508@intel.com>
	<1279318325.27733.21.camel@macbook.infradead.org>
Date: Fri, 16 Jul 2010 15:40:30 -0700
X-Google-Sender-Auth: E5Jd2umlXYcLdOScvMQxyK1X324
Message-ID: <AANLkTik80zwMaRYglVt2V3AuXiN90mgovIB3i67teVOL@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 3:12 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> Ah, that's the problem. Sorry, should have noticed this before. Since
> this is the catch-all IOMMU, the device isn't explicitly listed.
>
> You want 'drhd = dmar_find_matched_drhd_unit(pdev);' and then compare
> vtbar with the reg_base_addr of that one.
>

Care to send a new patch?

Chris
