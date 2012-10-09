Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2JIPkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:40:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2JIPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:40:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH 5/9] ARM: Xen: fix initial build problems:
Date: Tue, 9 Oct 2012 15:39:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <1349796183-30648-6-git-send-email-arnd@arndb.de> <1349796958.21847.219.camel@zakaz.uk.xensource.com>
In-Reply-To: <1349796958.21847.219.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091539.46274.arnd@arndb.de>
X-Provags-ID: V02:K0:ylQy+x6C8LRb8TrpfZWsuR/2ncIEiXNIYup01oRekDA
 0hiMb9q2+PlL3QEfRgTycAeNB0cLZKk0nV2eK1r/NE+UOysiA5
 i1wf7jBOltB6j2RHNx01dUKGuFnk5OJUjjEL8/WmwJ4jj2PvrW
 0LbwsqTCi9egWG7U1Xkx9IzfUIzo0KNiOJXBG7GXF0EcnDUrIR
 bSAxzJGAnOBEArPFdeUREDK1CYvhvaZ6r0xm4ax85Q/exReJfY
 XfmWWnsEuTQ27iuvazUmEoPen1LXf+XSfiJ+TDPxQ/9Kd1FV1k
 eiRu+Vf6w5oaI5AZ8Oy8RUqDQzwxIs0EkQmESJUqOkakQRupl0
 qxyUD262gMytNUOp6j2s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012, Ian Campbell wrote:
> > * The tmem hypercall is not available on ARM
> > 
> > * ARMv6 does not support cmpxchg on 16-bit words that are used in the
> 
> missing the end of this sentence?

Right, I meant to say 

* ARMv6 does not support cmpxchg on 16-bit words that are used in the
  Xen grant table code, so we must ensure that Xen support is only built
  on ARMv7-only kernels not combined ARMv6/v7 kernels.

This should be fixed differently in the future.

	Arnd
