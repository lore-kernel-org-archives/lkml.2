Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2L1LrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:47:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41661 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2L1LrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:47:18 -0500
Date: Fri, 28 Dec 2012 12:47:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mm: add generic kernel/ident mapping helper
Message-ID: <20121228114720.GB12363@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20121227185126.GA10207@x1.alien8.de>
 <CAE9FiQWekAOMedzr8Pj3d2O1g3KrN_Fd4F_D4SGz=gOTBZF8sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQWekAOMedzr8Pj3d2O1g3KrN_Fd4F_D4SGz=gOTBZF8sA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 04:34:03PM -0800, Yinghai Lu wrote:
> do you like to name it with kernel_ident_mapping_info ?

We have already kernel_ident_mapping_init so the first three words are
already the same. Besides, you're differentiating between kernel mapping
or ident mapping so ident_mapping_info is not that suitable too. Maybe
x86_mapping_info since it is x86-specific?

Thanks.

-- 
Regards/Gruss,
Boris.
