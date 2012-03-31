Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2CaUZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:25:13 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:51588 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752053Ab2CaUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:25:09 -0400
Message-ID: <4F77681E.5010608@xenotime.net>
Date: Sat, 31 Mar 2012 13:25:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linas Vepstas <linasvepstas@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-hexagon@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-mips@linux-mips.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        tglx@linutronix.de, linux@arm.linux.org.uk, dhowells@redhat.com,
        jejb@parisc-linux.org, linux390@de.ibm.com, x86@kernel.org,
        cmetcalf@tilera.com
Subject: Re: [PATCH RFC] Simplify the Linux kernel by reducing its state space
References: <20120331163321.GA15809@linux.vnet.ibm.com> <20120331201500.GA27640@linas.org>
In-Reply-To: <20120331201500.GA27640@linas.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2012 01:15 PM, Linas Vepstas wrote:

> 
> Hi,
> 
> I didn't actually try to compile the patch below; it didn't look like
> C code so I wasn't sure what compiler to run it through.  I guess maybe
> its python?  However, I'm very sure that the patches are completely
> correct, because I read them, and I also know Paul.  And I've heard of
> Thomas Gleixner.


x86_64 defconfig has many build errors and warnings.  :(

back to my abacus.

-- 
~Randy
