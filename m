Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2HOQRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:17:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58144 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HOQRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:17:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 27/31] arm64: Loadable modules
Date: Wed, 15 Aug 2012 16:16:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208151523.21447.arnd@arndb.de> <20120815153538.GA14264@arm.com>
In-Reply-To: <20120815153538.GA14264@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151616.56932.arnd@arndb.de>
X-Provags-ID: V02:K0:RnEHo3qFiXNkpDMpeYA8JZjDFH7/8zB0XX5dEpw+M1g
 nyOSBXnGksg/fbpG5DQpA4jx6rLkoEYuwvoSwaasOPDT2Kg6v0
 hm0doUtYmnpwkIqBqnqsLkco0YL7UwsziLDo/x0wW9dUPo+Rjz
 0wBczdMZf2iph1XBNYE5odjLXVF9e1uNMS1DprgKwrbxGPA00Z
 NoI+Z4VjySJcNIV49Xs2MsOMhWssVl8kWs4Bo/ehJfAPiHsnXP
 tWkXffn/L5WZsJVn5MIgsRcKFQiJxP0MHS9F0pBeJGFuyHbBOm
 Iwb3JVP3MLJKJ/3+3BfsUSTDhVrR93sH2C8wkkL8gsA5F9uzqw
 2YJcUx7Zpj6XB9ksOL1k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 August 2012, Catalin Marinas wrote:
> Primarily branch relocation, we have a limitation to 128MB branch range.
> The alternative would be to always compile the modules with a large
> memory model but we may lose some performance and could make the
> relocation handling even harder. What we do now is pretty much similar
> to static linking but at module load time.

Ok, makes sense.

	Arnd
