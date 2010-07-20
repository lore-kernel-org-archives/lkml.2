Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528Ab0GTUWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:22:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38109 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758629Ab0GTUWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:22:34 -0400
Message-ID: <4C46057C.10706@zytor.com>
Date: Tue, 20 Jul 2010 13:22:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
In-Reply-To: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 11:50 AM, Robert Richter wrote:
> 
> There is also one patch that removes boot_cpu_id variable, which is
> not really related to xsave. Maybe this should be applied to another
> branch.
> 

Probably, yes.

	-hpa
