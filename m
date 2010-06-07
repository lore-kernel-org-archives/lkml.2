Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0FGREB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 13:04:01 -0400
Received: from mail-yw0-f187.google.com ([209.85.211.187]:51644 "EHLO
	mail-yw0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0FGREA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 13:04:00 -0400
MIME-Version: 1.0
In-Reply-To: <20100607125343.cd109629.sfr@canb.auug.org.au>
References: <20100607125343.cd109629.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 7 Jun 2010 11:03:35 -0600
X-Google-Sender-Auth: pVAfLKpo3yEPbXV8rootAu9ZPmY
Message-ID: <AANLkTinfvexAjfzrLtQXqqCLIqootCGhaVLmajLC8rtO@mail.gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 8:53 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the devicetree tree got a conflict in
> drivers/usb/host/ehci-hcd.c between commit
> 1f23b2d98c11fed43c552a5dbd00c793f81a8736 ("usb: fix ehci_hcd build
> failure when both generic-OF and xilinx is selected") from the  tree and
> commit 4c018c4ab1edd8f4154848868960ebe132c3d138 ("usb/of: fix build
> errors") from the devicetree tree.
>
> They look like two version of the same fix.  I used the version from
> Linus' tree.

Yup, that's right.  The commit in my devicetree-next branch is stale
and has been superseeded.  I just hadn't pushed out the new tree yet.
I'm refresh it today.

Cheers,
g.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
