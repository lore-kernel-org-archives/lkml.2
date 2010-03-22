Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0CVOlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:41:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49032 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0CVOlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JqZid/OGpurERlCMRgenSvVYzg2vRYIXgEFEIl0jOTFaBMcrwKA8lwXVnuXzzmMZZ/
         nPizEy0+J9U4f+EUWFJS8Lvx62tDACdDtFt3C8cg7rM440AURE/tBrdSM+kUUS0BdJJ4
         s+gQ+Z9L7N2CSX+s8LpE9zYIX5KtU/zQ2zSJU=
MIME-Version: 1.0
In-Reply-To: <4BA7344C.6030108@linux.intel.com>
References: <4BA7344C.6030108@linux.intel.com>
Date: Mon, 22 Mar 2010 10:41:49 -0400
Message-ID: <5e61b72f1003220741s741c56bbn886243d02f6f66ac@mail.gmail.com>
Subject: Re: [BUGFIX] [PATCH] x86: update all PGDs for direct mapping changes 
	on 64bit.
From: John Villalovos <sodarock@gmail.com>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: ak@linux.intel.com, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       "Li, Haicheng" <haicheng.li@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 5:11 AM, Haicheng Li
<haicheng.li@linux.intel.com> wrote:
> Hello,
>
> In our recent CPU/MEM hotplug testing, a kernel BUG() was found:

Haicheng,

Maybe it is just my mail reader but the patch seems corrupted with
extraneous space characters.

Any chance it can be reposted?

Thanks,
John
