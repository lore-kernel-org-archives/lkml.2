Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1ARVtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:49:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44715 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751136Ab1ARVtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:49:13 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+o8Qgml3KoOQHVdWZb9p2sLshjA7DHgsurYoEpML
	AZWtH5CtxVoGwM
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH] staging/comedi/me4000: fix sparse warning "obsolete struct initializer"
Date: Tue, 18 Jan 2011 22:49:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; x86_64; ; )
Cc: Arun Thomas <arun.thomas@gmail.com>, Kulikov Vasiliy <segooon@gmail.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Gustavo Silva <silvagustavo@users.sourceforge.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1294697236-12016-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1294697236-12016-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101182249.11127.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 10 Januar 2011, 23:07:16 schrieb Peter Huewe:
> This patch fixes the sparse warnings in me4000.c:
> me4000.c:122:1: warning: obsolete struct initializer, use C99 syntax
> me4000.c:123:1: warning: obsolete struct initializer, use C99 syntax
> me4000.c:124:1: warning: obsolete struct initializer, use C99 syntax
> me4000.c:125:1: warning: obsolete struct initializer, use C99 syntax
> by converting the struct to use C99 syntax
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
 Ping - any updates on this one?

Thanks,
Peter
