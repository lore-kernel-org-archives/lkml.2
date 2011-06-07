Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1FGB1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 21:27:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56510 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab1FGB1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t8VMQVgt4DhWAEi/zA9naL1KOIwASz6J8aEg/acXoXCYSET26dv/JSwXOmnU3C6Z2z
         4MYm5F8N1WAoRxLuhSHslDI8gzP/qzir+uzzAJ1wiKxJ95wszGThgPIbfl8dANNrwSi4
         QCucdYe6nqDM9AygmGVzZu2eDKIAFVBhIBeuM=
MIME-Version: 1.0
In-Reply-To: <1307408678.4994.46.camel@Joe-Laptop>
References: <201106061349.00474.hartleys@visionengravers.com>
 <1307397174.4994.26.camel@Joe-Laptop> <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>
 <1307408678.4994.46.camel@Joe-Laptop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 6 Jun 2011 21:26:50 -0400
Message-ID: <BANLkTim2ni-8Ne9meL2gWvOtCr3Wr3EHNA@mail.gmail.com>
Subject: Re: [PATCH] treewide: Convert uses of struct resource * to resource_size(ptr)
To: Joe Perches <joe@perches.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 21:04, Joe Perches wrote:
>  drivers/mtd/maps/bfin-async-flash.c        |    2 +-

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
