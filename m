Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab1JDTLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:11:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60285 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab1JDTLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:11:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>
Subject: Re: [PATCH v4 06/24] C6X: early boot code
Date: Tue, 04 Oct 2011 21:11:17 +0200
Message-ID: <2079937.VAAxWVcgqc@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317746641-26725-7-git-send-email-msalter@redhat.com>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com> <1317746641-26725-7-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZkuNS/wGx1neQypuBlxN1Ch5rTSQrMiNoCnyE7lXDTz
 lm92IfkpCWy3ijIpjwSVbepxOjDvxpA0pBW4pAxh2k1DyQSRfF
 /A8w33KoNVOr3shRA8HrLQr+AtXqznIgbZgcIviOQPnnz8DPqY
 tP9SYRhftEUn5oCKkM64e4GK4egkwETIaXwqxVydHpGSm4mpsN
 xTKz4cxXdCsrcThzVHF5kvBn9og+DuS3+yRPFYKPqM/wG6kQyq
 yuuSH56xfsRZILDDiXDsVVNUx9CK4kE+b8IAxVZ8hLp32ZzfkK
 wSGSfPZvoMCZpmXCnIhFq8Fcd9raMk/xYND4X1AmxcwTFVXxWM
 jkTRpYdBWNolBmr7a/6A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011 12:43:43 Mark Salter wrote:
> From: Aurelien Jacquiot <a-jacquiot@ti.com>
> 
> Original port to early 2.6 kernel using TI COFF toolchain.
> Brought up to date by Mark Salter <msalter@redhat.com>
> 
> This patch provides the early boot code for C6X architecture. There is a
> 16 entry vector table which is used to direct reset and interrupt events. The
> vector table entries contain a small amount of code (maximum of 8 opcodes)
> which simply branches to the actual event handling code.
> 
> The head.S code simply clears BSS, setups up a few control registers, and calls
> machine_init followed by start_kernel. The machine_init code in setup.c does
> the early flat tree parsing (memory, commandline, etc). At setup_arch time, the
> code does the usual memory setup and minimally scans the devicetree for any
> needed information.
> 
> Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
