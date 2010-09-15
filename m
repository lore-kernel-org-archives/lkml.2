Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0IOQeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:34:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0IOQeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:34:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for September 15 (bkl-related)
Date: Wed, 15 Sep 2010 18:34:02 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20100915142954.6a36f52d.sfr@canb.auug.org.au> <20100915085910.a137904f.randy.dunlap@oracle.com>
In-Reply-To: <20100915085910.a137904f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009151834.02624.arnd@arndb.de>
X-Provags-ID: V02:K0:lnj9g07nnkAyocPNYHfoOMfUdBr/S/CocZ4jiMNIfsJ
 QZUk6yb1pZN9r6Fpxt0J0BkWRM+PLWVWIOYWxsv03EVzJWHxGs
 mHw2OaXEVq6BY5HMLq6MvYqMFFviZfkKq0HXXnmdIwyKzRqE2K
 umlO7PDFnx8T/Qrk9W6LBY4eBeM0kZjkdQH/CLOWaVK3GrJjMe
 BwaHBYmpaZlC5c9Et6bbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 September 2010, Randy Dunlap wrote:
> (1)
> drivers/pnp/isapnp/proc.c:50: error: expected '}' before 'else'
> 
> (2) when CONFIG_SCSI_PROC_FS is not enabled:
> drivers/scsi/sg.c:233: error: 'sg_mutex' undeclared (first use in this function)
> drivers/scsi/sg.c:1096: error: 'sg_mutex' undeclared (first use in this function)

Good catch, I'll fix these tonight.

Thanks,

	Arnd
