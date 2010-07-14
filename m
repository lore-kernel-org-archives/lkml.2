Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0GNOLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:11:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45733 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753729Ab0GNOLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:11:11 -0400
Date: Wed, 14 Jul 2010 15:11:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/5] drivers/regulator: Remove dead
 CONFIG_TWL4030_ALLOW_UNSUPPORTED
Message-ID: <20100714141108.GC31073@rakim.wolfsonmicro.main>
References: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 04:04:28PM +0200, Christian Dietrich wrote:
> CONFIG_TWL4030_ALLOW_UNSUPPORTED doesn't exist in Kconfig and is never
> defined anywhere else, therefore removing all references for it from
> the source code.
> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

Nack, you're missing the point of having this code here.
