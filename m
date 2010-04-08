Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab0DHA0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 20:26:41 -0400
Received: from ozlabs.org ([203.10.76.45]:54693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab0DHA0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 20:26:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and hvc_remove
Date: Thu, 8 Apr 2010 09:56:32 +0930
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Amit Shah <amit.shah@redhat.com>, Sachin Sant <sachinp@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       mingo@elte.hu, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20100319151326.GC8541@kroah.com> <20100326124340.GB7039@amit-x200.redhat.com> <20100406114238.GN5594@kryten>
In-Reply-To: <20100406114238.GN5594@kryten>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004080956.33405.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 09:12:38 pm Anton Blanchard wrote:
> The patch below changes things to call tty_kref_put once for every
> hvc_close call, and with that my machine boots fine.

Thanks, applied.

Cheers,
Rusty.
