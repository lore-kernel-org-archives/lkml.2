Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0CXLAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:00:22 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:56829 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab0CXLAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FkMindRfS90pD4HUXDjDW2rsKd7Q+dEzWAQtfCAJYW7NrYiVNMiymJDRxK2EaWyKlF
         VfBfgp6Dn3S5TPKAY+Hf/sFm1S9duy9p1pEGKXnaLtONdGcTTLAIy/8JQCz/2CaQhFkd
         GEQ3KatJpClM+R7SoRulslpKoBpMJf9AON+Yg=
MIME-Version: 1.0
In-Reply-To: <1269420538-18039-4-git-send-email-tj@kernel.org>
References: <1269420538-18039-1-git-send-email-tj@kernel.org>
	 <1269420538-18039-4-git-send-email-tj@kernel.org>
Date: Wed, 24 Mar 2010 13:00:18 +0200
X-Google-Sender-Auth: 25906faf2fbe607a
Message-ID: <84144f021003240400y43484fe6q8be4e8dc22284e9b@mail.gmail.com>
Subject: Re: [PATCH 3/4] include cleanup: Update gfp.h and slab.h includes to 
	prepare for breaking implicit slab.h inclusion from percpu.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       cl@linux-foundation.org, mingo@elte.hu, adobriyan@gmail.com,
       tglx@linutronix.de, hpa@zytor.com, yi.zhu@intel.com,
       reinette.chatre@intel.com, ilw@linux.intel.com,
       Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:48 AM, Tejun Heo <tj@kernel.org> wrote:
> With the actual patch, this message would end up ~1.7M which seems tad
> bit too large to send through LKML.  I said that I would post the
> whole patch on the last round but that was 200k and this one is 272K
> only with the diffstats and this one doesn't include any interesting
> stuff, so I'm snipping it again.  The whole patch is available at the
> following URL.
>
>  http://userweb.kernel.org/~tj/patches/0003-include-cleanup-Update-gfp.h-and-slab.h-includes-to-.patch

I didn't look at the patch but I agree with the principle. How do we
get this merged before we grow more implicit dependencies?
