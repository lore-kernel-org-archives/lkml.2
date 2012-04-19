Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab2DSJat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:30:49 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51248 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2DSJas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:30:48 -0400
Date: Thu, 19 Apr 2012 11:30:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/5] x86: Add symbolic constant for exceptions with error
 code
Message-ID: <20120419093032.GF29542@aftab>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <1334794610-5546-3-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334794610-5546-3-git-send-email-hpa@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 05:16:47PM -0700, H. Peter Anvin wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> 
> Add a symbolic constant for the bitmask which states which exceptions
> carry an error code.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
