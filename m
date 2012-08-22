Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2HVIot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:44:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54267 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab2HVInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:43:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 56/74] lto, workaround: Add workaround for missing LTO symbols in igb
Date: Wed, 22 Aug 2012 08:43:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-57-git-send-email-andi@firstfloor.org>
In-Reply-To: <1345345030-22211-57-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208220843.36047.arnd@arndb.de>
X-Provags-ID: V02:K0:7vRy4jjPvvtGagENurz9DiL/MO3PzRhs6i5wKfr2V4G
 6t8YRVZqLtPjBGEjl23MZ+XBGs7w7cEHV08r6dL0b6VCwKrT+Y
 9yD9zK10VE6MHiFmh4J903V9akiuIvIosrAttEgXd7gi31Mixy
 SoOQRiuPWOfCFWJvcI6KjcdmZ5GrPw3uGee6BE5DvAcyeNgOs7
 /4Qju/homIykm4eGrbIXmigsvR+ETATzaD/YMQGf6J+u8zLjJj
 0N717z4wThkasHEzwKuLT3qoJnZSjoop6l+vPMkZNG7lU1ZIAR
 ZLY6IYkcoqXnm0wkUxPWTTRjKFH3Lgmn/9wrqtN2d5NUlsNcVB
 hQZrsTzQeZaLOCPwgwmo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2012, Andi Kleen wrote:
> -static struct e1000_mac_operations e1000_mac_ops_82575 = {
> +/* Workaround for LTO bug */
> +__visible struct e1000_mac_operations e1000_mac_ops_82575 = {

The comment is not very clear outside the context of this patch.
Maybe change it to /* __visible added to work around an LTO but */.

	Arnd
