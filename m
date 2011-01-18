Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1ARVt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:49:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53399 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753032Ab1ARVt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:49:26 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+Nb8d6E0uNP/doZDiM6uSzX86bXUvc2ppoocH8OR
	f+2ALbf6GAk3f8
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH] staging/comedi/icp_multi: fix sparse warning "obsolete struct initializer"
Date: Tue, 18 Jan 2011 22:49:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; x86_64; ; )
Cc: Arun Thomas <arun.thomas@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1294697913-14467-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1294697913-14467-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101182249.24558.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 10 Januar 2011, 23:18:33 schrieb Peter Huewe:
> This patch fixes the sparse warnings
> "obsolete struct initializer, use C99 syntax" in icp_multi.c
> by converting the struct to C99 syntax
> 
> KernelVersion: linux-next-20110110
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
 Ping - any updates on this one?

Thanks,
Peter
