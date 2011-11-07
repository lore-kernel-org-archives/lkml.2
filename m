Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1KGSCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:02:52 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40960 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab1KGSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:02:50 -0500
Date: Mon, 7 Nov 2011 19:02:47 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, bp@amd64.org,
        mingo@elte.hu, hpa@zytor.com, andreas.herrmann3@amd.com,
        amd64-microcode@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 Microcode: Fix the failure path of microcode update
 driver init code
Message-ID: <20111107180247.GE9694@aftab>
References: <20111107123530.12164.31227.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107123530.12164.31227.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 06:05:32PM +0530, Srivatsa S. Bhat wrote:
> The microcode update driver's initialization code does not handle failures
> correctly. This patch fixes this issue.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Looks ok, applied.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
