Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1KYJsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 04:48:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1KYJsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 04:48:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] MISC: convert drivers/misc/* to use module_platform_driver()
Date: Fri, 25 Nov 2011 09:48:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Pratyush Anand <pratyush.anand@st.com>,
        Pavan Savoy <pavan_savoy@ti.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>
References: <1322195099.30842.4.camel@phoenix>
In-Reply-To: <1322195099.30842.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111250948.09761.arnd@arndb.de>
X-Provags-ID: V02:K0:K0rP4JZMeihsVoWJFI3QJzPp4Dfy+7USYLrWiChaw+a
 cqmXRPb/9PsAXNY8P6QuPni7+7NA4THiv0gpGxnlNCLdx1aE7E
 gwHP6424Ib6tuqHHDPfeRoZtAUP9/Psd0LkKZM7EG7tqwqJtyH
 AxJCH//nb8em56xJBuRF6plrqzaQpray3u8gYt46TUu9gPaCw7
 jmF/V/57V/EqWzwYmPza3LWeNGHDkk3Azbfh4/xotpj6TojFAA
 EgtvTQuNajV+9Wq/qxScBRoqYSvjhjJNqZnnx8P6GT0hmi6pVe
 /WcH6QQeYxhZszOqwKBiEGon7wClBtLjUdItXPMB/G3R85qa+D
 q+7zx45pIMoAQvfe3eXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 November 2011, Axel Lin wrote:
> 
> This patch converts the drivers in drivers/misc/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Ira W. Snyder <iws@ovro.caltech.edu>
> Cc: Pratyush Anand <pratyush.anand@st.com>
> Cc: Pavan Savoy <pavan_savoy@ti.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
