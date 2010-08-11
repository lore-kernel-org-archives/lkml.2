Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0HKQmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:42:54 -0400
Received: from claw.goop.org ([74.207.240.146]:55912 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab0HKQmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:42:52 -0400
Message-ID: <4C62D309.5010909@goop.org>
Date: Wed, 11 Aug 2010 09:42:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] paravirt: noreplace-paravirt is implemented for x86 and
 ia-64
References: <alpine.LNX.2.00.1008111832510.2702@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1008111832510.2702@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/11/2010 09:34 AM, Jiri Kosina wrote:
> kernel-parameters.txt lists 'noreplace-paravirt' parameter as being
> limited to X86-32, which is incorrect -- it's actually supported by
> x86-32, x86-64 and ia-64.
>
> Signed-off-by: Jiri Kosina<jkosina@suse.cz>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> ---
>   Documentation/kernel-parameters.txt |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index d529b13..8ed3a77 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1777,7 +1777,7 @@ and is between 256 and 4096 characters. It is defined in the file
>   	norandmaps	Don't use address space randomization.  Equivalent to
>   			echo 0>  /proc/sys/kernel/randomize_va_space
>
> -	noreplace-paravirt	[X86-32,PV_OPS] Don't patch paravirt_ops
> +	noreplace-paravirt	[X86,IA-64,PV_OPS] Don't patch paravirt_ops
>
>   	noreplace-smp	[X86-32,SMP] Don't replace SMP instructions
>   			with UP alternatives

