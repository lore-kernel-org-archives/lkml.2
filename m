Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1GVKrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:47:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52802 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1GVKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:47:32 -0400
Subject: Re: [PATCH v3] regulator: Fix memory leak in
 set_machine_constraints() error paths
From: Liam Girdwood <lrg@kernel.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1310698243.2384.1.camel@phoenix>
References: <1310698243.2384.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 11:47:16 +0100
Message-ID: <1311331636.3312.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 10:50 +0800, Axel Lin wrote:
> Properly kfree rdev->constraints in all set_machine_constraints() error paths.
> Also properly kfree rdev->constraints in regulator_register() error paths.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

Thanks

Liam

