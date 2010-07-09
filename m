Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0GIWA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:00:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40466 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0GIWAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=s9l8yamBkAlXvf448l+Y9Y79CWDtLcVC45nF6QgoubUKXLvqaqyCvtOcH6JNYB++Y3
         x7GSuG/XGrfQMyqQCyL7LiboU9QQtEa5WzTkzLRLpCV72ePALVUwEZ9V3Xe7ZKjhK8b/
         x+GGPhLNZ3rPFkUtANW8I0DsBOAZJ4TbT5Imk=
MIME-Version: 1.0
In-Reply-To: <4C379462.1020704@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C2A8879.8010000@intel.com>
	<AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
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
Date: Fri, 9 Jul 2010 15:00:22 -0700
X-Google-Sender-Auth: vrFgU1LfGHGVHvgX-W-V1IzM84Q
Message-ID: <AANLkTin5U93euGc4QFUJIE2RpTY8x_J3dNhd2EgWuhRu@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 2:28 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Same as the original result, ioatdma blocked from accessing memory, no
> report about BIOS borkage.

If you have newer patch to address that, I will give it a try.

Chris
