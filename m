Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab1ANBj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:39:28 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:33079 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757292Ab1ANBjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:39:20 -0500
MIME-Version: 1.0
In-Reply-To: <1294262733-9585-1-git-send-email-fernando.lugo@ti.com>
References: <1294262733-9585-1-git-send-email-fernando.lugo@ti.com>
Date: Thu, 13 Jan 2011 19:39:19 -0600
Message-ID: <AANLkTi=xedun+g=5295CFZXPn=2nPuVUhC4TPVsPR4Ya@mail.gmail.com>
Subject: Re: [PATCHv2] staging: tidspbridge: configure full L1 MMU range
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 5, 2011 at 3:25 PM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:
> From: Guzman Lugo, Fernando <fernando.lugo@ti.com>
>
> IVA MMU can manage up to 4GB of address space through its page tables,
> given that it's L1 is divided into 1MB sections it requires at least
> 16KB for its table which represents 4096 entries of 32 bits each.
>
> Previously, only 1GB was being handled by setting the page table size
> to 4KB, any virtual address beyond of the L1 size used, would fall
> into memory that does not belong to L1 translation tables, leading to
> unpredictable results.
>
> So, set the L1 table size to cover the entire MMU range (4GB) whether
> is meant to be used or not.
>
> Reported-by: Felipe Contreras <felipe.contreras@nokia.com>
> Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
> Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>

Nice fix, pushed to for-gkh-2.6.38 branch.

Regards,

Omar
