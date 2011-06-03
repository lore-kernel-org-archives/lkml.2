Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1FCWwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:52:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46442 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab1FCWwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:52:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FDx509LSgl3EIBFZImarpKLtQjnzu6Br9frlqTmzvYHtZq6TxrZ2cFf/UovJEolcUQ
         0+XeXA6qgpn6O4BkNTihrUskVSIs8NyfgFjUr6u44r771oFKDkaXEI9nAWwp9PYdh81P
         XRS3Ob64sZ5YxeD0KT8kXnxe/LJracqcyrD9E=
MIME-Version: 1.0
In-Reply-To: <20110603220451.23134.47368.stgit@paris.rdu.redhat.com>
References: <20110603220451.23134.47368.stgit@paris.rdu.redhat.com>
Date: Fri, 3 Jun 2011 15:52:09 -0700
X-Google-Sender-Auth: q22O4eHy6fP53swHBUJ-T83rt3g
Message-ID: <BANLkTik4qRe--C6L5WU3XvpP-TMEZ6RQ-w@mail.gmail.com>
Subject: Re: [PATCH -v2] Audit: push audit success and retcode into arch ptrace.h
From: Tony Luck <tony.luck@intel.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, fenghua.yu@intel.com, monstr@monstr.eu,
        ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        lethal@linux-sh.org, davem@davemloft.net, jdike@addtoit.com,
        richard@nod.at, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, viro@zeniv.linux.org.uk, oleg@redhat.com,
        akpm@linux-foundation.org, linux-ia64@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 3:04 PM, Eric Paris <eparis@redhat.com> wrote:
> The other major change is that on some arches, like ia64, we change
> regs_return_value() to give us the negative value on syscall failure.  The
> only other user of this macro, kretprobe_example.c, won't notice and it makes
> the value signed consistently for the audit functions across all archs.

v2 builds and boots on ia64 now
Acked-by: Tony Luck <tony.luck@intel.com>


> Signed-off-by: Eric Paris <eparis@redhat.com>
> Acked-by: Acked-by: H. Peter Anvin <hpa@zytor.com> [for x86 portion]

  ^^^^^^^^^^^^^^^^^^^^  :-)

-Tony
