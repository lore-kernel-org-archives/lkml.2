Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab1JDTXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:23:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab1JDTXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:23:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>
Subject: Re: [PATCH v4 21/24] C6X: general SoC support
Date: Tue, 04 Oct 2011 21:23:06 +0200
Message-ID: <1591836.h3shdl2SaF@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317746641-26725-22-git-send-email-msalter@redhat.com>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com> <1317746641-26725-22-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o4xTpT2TagqL4CBE+9jV18xU/LiD3W/7kUxO241pFp0
 UpFWoBL9yWsl0LiRTcZQk40EFYqcO4PgKl8vSIYdLQ0tyxKoQ3
 AYtqdMObH3vIBsUwwpjcfyuAHLGNkekXHtyDOAm1B89L7FwbNg
 EYEDSD07yf6tgU4BI/OyEC1af6m9cO2VicbumB/GptoB+0U0fa
 XQHgAiP1ov0RMW5RnpL3Ynwvtw0dTUf+JBtFJU9pk9eZ/ZeelO
 Wtvgb90iO0gRF7bQhl6Swj3Rx2iQAv4BLybhxRhxTiSiUka1cJ
 nvu+7cGQhx4UF7dDbDW8dhOQCAUllM12T9+b753C3p6UrclgM4
 s5dcPMllMWtAOBhI4gmA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011 12:43:58 Mark Salter wrote:
> This patch provides a soc_ops struct which provides hooks for SoC functionality
> which doesn't fit well into other places.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
> CC: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
