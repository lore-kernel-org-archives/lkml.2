Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab1EaPtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:49:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:40204 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab1EaPtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:49:21 -0400
From: Richard Weinberger <richard@nod.at>
To: Christoph Lameter <cl@linux.com>
Subject: Re: slub: UML and CONFIG_CMPXCHG_LOCAL
Date: Tue, 31 May 2011 17:47:19 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, penberg@kernel.org
References: <201105292225.46544.richard@nod.at> <alpine.DEB.2.00.1105310929230.18004@router.home>
In-Reply-To: <alpine.DEB.2.00.1105310929230.18004@router.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105311747.19467.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 31 Mai 2011, 16:30:21 schrieb Christoph Lameter:
> > Is there anything I can do to have slub on UML?
> 
> Yes, rely on the generic implementation of this_cpu_cmpxchg.

Thanks for the pointer.
You helped me a lot!

//richard

