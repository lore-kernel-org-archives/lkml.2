Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab0FWKgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:36:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39963 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0FWKgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hqCZ7cYXmVJD4XmIQA7tCnve0M4pChaFXHGyzRaJ/VHdY48b/5FFrauHM2Woz8H/X6
         oQ3j6fBmJvUZb0+ZQIGpp5kYYNvc3nVSco04cHgGgVqpnCcCZE01t+7Im1JEAcMIH9G8
         lxRMdmmqGtGiZfj/wbCa8kTSypquxjcbZPj6k=
Date: Wed, 23 Jun 2010 12:36:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, x86@kernel.org,
       Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Greg Ungerer <gerg@uclinux.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/40] x86, compat: convert ia32 layer to use
Message-ID: <20100623103619.GC5242@nowhere>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-13-git-send-email-imunsie@au1.ibm.com> <20100623101402.GA10564@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623101402.GA10564@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 12:14:02PM +0200, Christoph Hellwig wrote:
> Any reason we need to differenciate between COMPAT_SYSCALL_DEFINE and
> ARCH_COMPAT_SYSCALL_DEFINE?  We don't need this for native system calls,
> so I can't see the reason to do it for compat system calls.
> 


I think we wanted that to keep the sys32_ prefixed based naming, to avoid
collisions with generic compat handler names.

