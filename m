Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0I2PrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:47:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44698 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0I2PrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BHAJvtEwtQN6fPv/7X9I2Amp4nDekvHmCBZ0x14wmQx4BthU3MAQhHXfhqDolGiL7S
         0ABNGftoSqyi9C80Xdoyw1tsuOvDZzARwkD55dNOOha/JPOb58nISR24IeMmfuDsZwR/
         Y0jaE2JkxukHQdfFzklKC+EBgtYIMFrycE36U=
MIME-Version: 1.0
In-Reply-To: <1285761235-4751-2-git-send-email-ying.huang@intel.com>
References: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
	<1285761235-4751-2-git-send-email-ying.huang@intel.com>
Date: Wed, 29 Sep 2010 08:47:13 -0700
X-Google-Sender-Auth: y0yGFkD6If3v80pMEQFgUcJOOpY
Message-ID: <AANLkTi=JkcJiQhxLSmU2vgmrACPSrE16cEhRnxCOr_5g@mail.gmail.com>
Subject: Re: [PATCH -v2 1/5] ACPI, APEI, Fix APEI related table size checking
From: Yinghai Lu <yinghai@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 4:53 AM, Huang Ying <ying.huang@intel.com> wrote:
> On Huang Ying's machine:
>
> erst_tab->header_length == sizeof(struct acpi_table_einj)

So it seems your system firmware violates the 4.0 spec

Yinghai
