Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1FFQbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:31:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48970 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1FFQbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YPn3IXZmvQvrSTxwIOOUDcY1PQCoGEYW9FMaji5PKjiy4/NkVOsSLR5hlahr6nMDmM
         DnuvD6HE+VNClK2FjDPMR22IVwSrZwv2BCYT3evCivZxw4Xeki7hPBjzbEujb1zWKmrt
         JRejEDNjctzOZOTXSquOE9GGYjjG/xqvDenqE=
MIME-Version: 1.0
In-Reply-To: <20110606071829.10334.90865.stgit@ponder>
References: <20110606071829.10334.90865.stgit@ponder>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 6 Jun 2011 12:31:12 -0400
Message-ID: <BANLkTinqVf+uK+5T_X-EkXw-YE67DJL1Pg@mail.gmail.com>
Subject: Re: [PATCH v2] spi: reorganize drivers
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 03:18, Grant Likely wrote:
> Sort the SPI makefile and enforce the naming convention spi_*.c for
> spi drivers.

spi_topcliff_pch.c uses KBUILD_MODNAME with a few funcs, but perhaps
those are only for /proc/ status tracking ?  worth double checking ...
-mike
