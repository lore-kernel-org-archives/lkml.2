Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab2JLPPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:15:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51419 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2JLPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:15:18 -0400
Date: Fri, 12 Oct 2012 17:15:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/8] Improve performance of VM translation on x86_64
Message-ID: <20121012151517.GC16230@one.firstfloor.org>
References: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com> <CACJDEmomjBk5CkLBWGdyAtKNgV_f39d6kWM5=Ko2Nx5GDmw5Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACJDEmomjBk5CkLBWGdyAtKNgV_f39d6kWM5=Ko2Nx5GDmw5Jg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you also add  a blurb in the Documentation/< appropriate file
> for device driver writes> mentioning the usage of __pa_symbol is
> preferred?

Device driver writer's shouldn't use any of this anyways, they should always
use the PCI DMA APIs and never DMA to the stack or to static variables.

-Andi
