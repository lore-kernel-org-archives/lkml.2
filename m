Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1HQUjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:39:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58975 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab1HQUjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch 06/36] Hexagon: Add processor and system headers
Date: Wed, 17 Aug 2011 21:31:46 +0200
Message-ID: <2190987.TyqYXCu926@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163520.423419116@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163520.423419116@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SpRHHcAcpXhVs9bwFlVvsdyR+BdmorNZaZS+I7Vd1rV
 p2i23KI54VVYRG9shVcyV1dmQAH4J3FKI3GyAix+OWfJSRdCzs
 XGduxLjYhwb0J6M/kJeVj9c5+SRXjX5ztNZyYsKs2+rgE7n58m
 t2+wdVQBev4ORbHevVfCZL45kUD7z18jnP2DVK/KbbimOkYTs3
 vX3BZF6zh3gXfQYZ1k6cg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:03 Richard Kuo wrote:

> +
> +#define cpu_relax() barrier()

If you run under a hypervisor, you might want to call a 'yield' hypercall.

	Arnd
