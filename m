Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1KQTaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:30:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41615 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab1KQTaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:30:00 -0500
Message-ID: <4EC560AB.4050907@zytor.com>
Date: Thu, 17 Nov 2011 11:29:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/platform: (TS-5500) fix CONFIG_TS5500_ADC dependency
References: <1321555012-14331-1-git-send-email-vivien.didelot@savoirfairelinux.com> <4EC554CA.5070802@zytor.com> <20111117135731.1c8e736e@v0nbox>
In-Reply-To: <20111117135731.1c8e736e@v0nbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 10:57 AM, Vivien Didelot wrote:
> 
> IMHO it would be overkill for such a small embedded platform to provide
> device drivers as modules.
> 

You have it exactly backwards.  It should be possible to have these
drivers available in a generic kernel without burdening all systems in
the world.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

