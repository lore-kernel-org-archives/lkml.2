Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab1DASvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:51:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33637 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab1DASvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:51:48 -0400
Message-ID: <4D961EAB.6090002@zytor.com>
Date: Fri, 01 Apr 2011 11:51:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Ingo Molnar <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop> <20110401062338.GA6434@elte.hu> <alpine.DEB.2.00.1104011212070.16492@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1104011212070.16492@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 04:30 AM, Stefano Stabellini wrote:
> 
> P.S.
> I asked for a backport of e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e to
> the stable trees because I forgot to add "CC stable@kernel.org" to the
> commit message and this commit is needed to fix a critical crash on boot
> on xen.

Yes, and you broke ALL machines in the process.  Great job.

	-hpa
