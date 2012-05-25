Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2EYGX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:23:56 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40281 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2EYGXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:23:55 -0400
Date: Fri, 25 May 2012 08:24:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Chen Gong <gong.chen@linux.intel.com>,
        tony.luck@intel.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
Message-ID: <20120525062426.GB3179@aftab.osrc.amd.com>
References: <20120524174943.989990966@linutronix.de>
 <20120524175056.478167482@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524175056.478167482@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 05:54:52PM +0000, Thomas Gleixner wrote:
> Intentionally left blank to be filled out by someone who wants that and
> can explain the reason for this better than me.

That'll be Intel folk :)

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Looks good to me too, thanks Thomas for doing this!

I'll run it next week just in case.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
