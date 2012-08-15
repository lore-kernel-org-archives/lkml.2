Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab2HOM5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:57:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62962 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2HOM5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:57:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 01/31] arm64: Assembly macros and definitions
Date: Wed, 15 Aug 2012 12:57:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-2-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-2-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151257.33405.arnd@arndb.de>
X-Provags-ID: V02:K0:Ikz/hc8zyaBSKmiejhtqc/mYrdEJZ97+0mh+EFINJI4
 gxPhUrS3f8O0/I90HO9YJtfWLrLXKEQcotIhD8QcE12b42GKdR
 V5crHXrmrykw3wTijjyACxf6q5AJVaZjeeGA4HfN0G8F3wkOOv
 lCIJTWeykSTudu2qQFp8jDT//5Ry99CTdaDQTSql6vIYnnp2Y4
 jlZk1S7UDZbwRIlxx8Sv/q9ZimZmeMusKc4Efb+938F/7f8giH
 2BgVBiRewPI4MC5ebTVaaCLPG0njRIxaxIu4DHXmGJaEkA6HPt
 eakYtgKSMiTjgaJB5O/bAqgXcknM1RfDiw++IsyL5yWLwVyd1Y
 CPcDXDs9WylGWpLTPyUs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> This patch introduces several assembly macros and definitions used in
> the .S files across arch/arm64/ like IRQ disabling/enabling, together
> with asm-offsets.c.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
