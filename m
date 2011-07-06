Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1GFUwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:52:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab1GFUwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:52:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v4 2/2] ARM: l2x0: Add OF based initialization
Date: Wed, 6 Jul 2011 22:52:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux@arm.linux.org.uk, Barry Song <21cnbao@gmail.com>,
        workgroup.linux@csr.com, Olof Johansson <olof@lixom.net>,
        tglx@linutronix.de, weizeng.he@csr.com,
        Grant Likely <grant.likely@secretlab.ca>
References: <1309984979-8847-1-git-send-email-robherring2@gmail.com> <1309984979-8847-2-git-send-email-robherring2@gmail.com>
In-Reply-To: <1309984979-8847-2-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107062252.16667.arnd@arndb.de>
X-Provags-ID: V02:K0:Dcdr7ZdBtjmGCxsWcuxyq+78OjSpUhxD2cwM4fUgsCg
 qODvUN8FIJV9CwhFg8Cc/k8CtkgrM3V4cpdAhOpNAVp5TESiYe
 PaxRkvlYwwHQAeYAjpKA6HtNEJHlqmhyRe7+N6ncezXdaOPTkq
 JMEzAKXDyk3wc4GbZMjRAIp5zOh9jqaRHoFF1jOVKDS8dcLJSX
 /ZJPF7khc+XlFEMSk3A3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 July 2011 22:42:59 Rob Herring wrote:
> 
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This adds probing for ARM L2x0 cache controllers via device tree. Support
> includes the L210, L220, and PL310 controllers. The binding allows setting
> up cache RAM latencies and filter addresses (PL310 only).
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
