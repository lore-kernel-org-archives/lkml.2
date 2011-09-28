Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab1I1Ns2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:48:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1I1NsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:48:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 10/24] C6X: signal management
Date: Wed, 28 Sep 2011 15:48:21 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-11-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-11-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281548.21252.arnd@arndb.de>
X-Provags-ID: V02:K0:PGmzOG+T8vayIBZrRek2V4y5lHq3BTrXrO5O6LPPjfr
 2ByDSyB9gw4LVWpHHc+FnxCGunjgjf2Aj7aBhN64k9lloQ11n9
 8RbA0Xs+WpmfMA8QviDF5nnX5v23LXIOKJlEe897jHAL53EfxI
 da7MR3TngIrDr3wMTQPejJow9WyIkvnqcWlWgc9qJR7Rhvpj/p
 3vY0ur3inCFSxWKYef1o/ysqxAZCZTDTPX/JNALJ9A5FKLxk2t
 1Lq+rQ/B50yf1020m3xDLxyiqQDYZ66MVriWJufQTLbmzSXogp
 LDbyaK3jrFBVXewa3Kkp8s4qFm3mCUrf27Kv8xf3u5KiTxd6Ir
 pBpFkrPZfrpM664d6MHQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/c6x/include/asm/sigcontext.h |   80 ++++++++
>  arch/c6x/include/asm/signal.h     |   17 ++
>  arch/c6x/kernel/signal.c          |  377 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 474 insertions(+), 0 deletions(-)
>  create mode 100644 arch/c6x/include/asm/sigcontext.h
>  create mode 100644 arch/c6x/include/asm/signal.h
>  create mode 100644 arch/c6x/kernel/signal.c
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
