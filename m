Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1LHOh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:37:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37695 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1LHOh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:37:26 -0500
Date: Thu, 8 Dec 2011 15:37:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>,
        davej@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 07/10] cpufreq: Add support for x86 cpuinfo auto loading
Message-ID: <20111208143725.GD24062@one.firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org> <1323304882-27953-8-git-send-email-andi@firstfloor.org> <20111208084958.GA23245@gere.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208084958.GA23245@gere.osrc.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, there is CPUID_8000_0007_EDX[7] which denotes the presence
> of the P-state registers. It probably could be added to
> init_scattered_cpuid_features() but there's still special handling
> needed for K8.

Dave is probably right that it's not worth moving the list.

> Can you do both a family and a feature bit test with the autoprobing
> code?

Yes.
-Andi
