Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2GJShk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 14:37:40 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42494 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2GJShj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 14:37:39 -0400
References: <20120710111756.GA11351@localhost>
In-Reply-To: <20120710111756.GA11351@localhost>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <CF1C132D-2873-408A-BCC9-B9F57BE6EDDB@linuxfoundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (9B206)
From: Christoph Lameter <christoph@linuxfoundation.org>
Subject: Re: linux-next: Early crashed kernel on CONFIG_SLOB
Date: Tue, 10 Jul 2012 13:37:35 -0500
To: "wfg@linux.intel.com" <wfg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent a patch yesterday (or was it friday) to fix the issue. Sorry @airport right now. 



On Jul 10, 2012, at 6:17, wfg@linux.intel.com wrote:

> Hi Christoph,
> 
> This commit crashes the kernel w/o any dmesg output (the attached one
> is created by the script as a summary for that run). This is very
> reproducible in kvm for the attached config.
> 
>        commit 3b0efdfa1e719303536c04d9abca43abeb40f80a
>        Author: Christoph Lameter <cl@linux.com>
>        Date:   Wed Jun 13 10:24:57 2012 -0500
> 
>            mm, sl[aou]b: Extract common fields from struct kmem_cache
> 
> Thanks,
> Fengguang
> <dmesg-kvm-waimea-2191-2012-07-10-17-32-01>
> <config-3.5.0-rc6+>
