Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab2FAOyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:54:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39987 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab2FAOyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:54:06 -0400
Message-ID: <4FC8D766.1070700@zytor.com>
Date: Fri, 01 Jun 2012 07:53:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/4] x86, CPU, AMD: Cleanup AMD-specific MSR-rw users
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
In-Reply-To: <1338562358-28182-1-git-send-email-bp@amd64.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 07:52 AM, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Ok,
> 
> the following patchset should take care of all the {rd,wr}msrl_amd_safe
> headaches we had this week. After it is applied, the AMD-specific
> variants become private to amd.c and issue a warning when used on
> anything else beside K8.
> 
> This also contains the two patches from Andre which cleanup the PV-side
> of things.
> 

Looks good.  This can be for 3.6, right (no immediate urgency)?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

