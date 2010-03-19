Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab0CSU2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:28:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab0CSU2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:28:02 -0400
Date: Fri, 19 Mar 2010 13:27:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, dwmw2@infradead.org, eric@anholt.net,
       ben@decadent.org.uk, gregkh@suse.de
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
 entries in i915
Message-Id: <20100319132723.118cc16a.akpm@linux-foundation.org>
In-Reply-To: <ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
References: <1268258994.2183.14.camel@carter>
	<ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
	<20100311083404.GG6896@zhen-devel.sh.intel.com>
	<ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 16:54:26 +0100
Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> Attached dmesg, lspci -vv, config and xorg.
> 
> When the X server crashes, the kernel does not report anything

This seems to have gone all quiet?

As this was a 2.6.32->2.6.32.4 regression, I assume that it's also a
2.6.32->2.6.33 regression?
