Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1HQUjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:39:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1HQUjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch 34/36] Hexagon: Add configuration and makefiles for the Hexagon architecture.
Date: Wed, 17 Aug 2011 22:27:20 +0200
Message-ID: <1439336.IEGvqVMOO9@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163523.041764598@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163523.041764598@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:k/WO0I6Y6D6WBBSK546UZtLmUy7v9K3TJezyikjZl+H
 xijjHh0KzmKJC7r7MRWhFYUbi1KkxVBvf0KpfnHvXPnPyl7WVb
 MQH4oZgXECWD8LTNz7TmWAxDt6KcQhcFSY6O7ktw3dDiQOoXJk
 mDuZctYVum3OS9kUv04oR44Jiul5a0ZcOWfGyW5A9s6+erjGvI
 wPw2uyiOMWwV03yLncM3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:31 Richard Kuo wrote:

> +config HIGHMEM
> +	bool "High Memory Support"
> +	default n

Do you really want to burden yourselves with this?

Support for HIGHMEM is gradually going to get worse as we optimize the
common 64-bit case in the kernel, so it may just not be worth it.

	Arnd
