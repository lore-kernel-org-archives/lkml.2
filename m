Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2EDPb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:31:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18974 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2EDPb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:31:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 04 May 2012 08:31:25 -0700
Subject: Re: [PATCH] drivers/power/sbs-battery.c: capacity attr = remaining
 relative capacity
From: Rhyland Klein <rklein@nvidia.com>
To: Nikolaus Voss <n.voss@weinmann.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
In-Reply-To: <201204250721.q3P7LmQN009128@gatekeeper.vosshq.de>
References: <201204250721.q3P7LmQN009128@gatekeeper.vosshq.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 4 May 2012 08:24:43 -0700
Message-ID: <1336145083.2210.1.camel@rhyland-vb>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 23:59 -0700, Nikolaus Voss wrote:
> Currently, the capacity exported by this driver refers to reg 0x0e,
> which is the absolute state of charge which according to SBS
> refers to the design capacity/ energy of the battery. It can be
> > 100 % and drops below 100 % for a fully charged battery with
> the battery aging.
> 
> This is not what the user exspects of a remaining capacity
> indication between 0 and 100 % with 100 % referring to
> a fully charged battery. This is provided by SBS reg 0x0d,
> which is the relative state of charge referring to the
> full charge capacity.
> 
> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
> ---
>  drivers/power/sbs-battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Ack-ed Rhyland Klein <rklein@nvidia.com>

