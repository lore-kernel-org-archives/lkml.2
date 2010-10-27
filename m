Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab0J0H7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:59:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54395 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab0J0H7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:59:49 -0400
Date: Wed, 27 Oct 2010 09:59:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Tim Bird <tim.bird@am.sony.com>, andi@firstfloor.org
Subject: Re: [PATCH] archs: add ioremap_change_write_prot
Message-ID: <20101027075947.GB2472@basil.fritz.box>
References: <4CC3F13B.4030107@gmail.com>
 <alpine.LFD.2.00.1010261818300.3115@localhost6.localdomain6>
 <AANLkTikyunbd2ACuS0mzR7NV0sfWFRdGRaxna9ZPM-Nt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikyunbd2ACuS0mzR7NV0sfWFRdGRaxna9ZPM-Nt@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However it needs to adds a define or something similar to know if the
> archs implements or not this interface. Suggestions about this point?

That's fine, you can do that in Kconfig. I think you already had that
in the earlier patch: just give it a better name.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
