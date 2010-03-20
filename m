Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0CTNE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:04:59 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54600 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab0CTNE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HaEdnTPmSxg3ksa+YHJCjHH86O/hndwgAa6JNEjJveciCYqpbilCWEZmWFi85c0wfN
         F+mZbG07OTHGl1wTUXJUD7OSUzArZTyiIpYNQUTDqJAqRjL8H4E6SDU2vBPeRmBkOFna
         b3XVnazZQZOvXibbSpWJZHeLagr08sbo2Z6QA=
MIME-Version: 1.0
In-Reply-To: <20100319132723.118cc16a.akpm@linux-foundation.org>
References: <1268258994.2183.14.camel@carter>
	 <ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
	 <20100311083404.GG6896@zhen-devel.sh.intel.com>
	 <ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
	 <20100319132723.118cc16a.akpm@linux-foundation.org>
Date: Sat, 20 Mar 2010 14:04:56 +0100
Message-ID: <ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
	entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, dwmw2@infradead.org, eric@anholt.net,
       ben@decadent.org.uk, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 9:27 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 11 Mar 2010 16:54:26 +0100
> Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>
>> Attached dmesg, lspci -vv, config and xorg.
>>
>> When the X server crashes, the kernel does not report anything
>
> This seems to have gone all quiet?

It seems so, I was about to ping Zhenyu.

>
> As this was a 2.6.32->2.6.32.4 regression, I assume that it's also a
> 2.6.32->2.6.33 regression?

Yep. All kernels I tested since 2.6.32.4 crash, including 2.6.32.10,
2.6.33 and 2.6.34-rc1. See my original message for more details about
the crash.

>
