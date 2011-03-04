Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab1CDPuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:50:39 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41247 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759838Ab1CDPuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:50:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=mtCixTdzrV75SvHWnSjnY639YHvjFsgShNZZF6JPzCvViLC6k0hj5Cvc5Y9sJj/+N4
         Z9eEw7hhccxlcaZdAF6yw4nKIZ+t+632uGetSbLq/nQtItQFRMtmeWxXRbf98Hb5knot
         cUY+3xvDSCC5GnyM+9jv6KhHD3tpe6VKJWwHk=
MIME-Version: 1.0
In-Reply-To: <20110304154549.GA14672@darkstar>
References: <20110304154549.GA14672@darkstar>
Date: Fri, 4 Mar 2011 23:50:36 +0800
Message-ID: <AANLkTin6BzvErgnTjAi7nyPtrDnunzRGe-TD3gc3pdku@mail.gmail.com>
Subject: Re: sysctl: add proc_dointvec_bool handler
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 11:45 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Add proc_dointvec_bool sysctl handler for cases value is limited to 0 and 1
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
>  include/linux/sysctl.h |    2 ++
>  kernel/sysctl.c        |   27 +++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
>
> --- linux-2.6.orig/kernel/sysctl.c      2011-03-03 11:13:01.986661838 +0800
> +++ linux-2.6/kernel/sysctl.c   2011-03-03 11:15:52.196661447 +0800

This one is PATCH 01/04,  I missed the info in subject

-- 
Regards
dave
