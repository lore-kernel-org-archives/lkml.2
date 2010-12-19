Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0LSN1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 08:27:46 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:34733 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab0LSN1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 08:27:45 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275dhz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LDOG23-01-GR9-02
X-M-MSG: 
Date: Sun, 19 Dec 2010 14:27:39 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/2] oprofile, x86: updates for AMD family 15h systems
Message-ID: <20101219132739.GC21053@erda.amd.com>
References: <1291981746-22114-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1291981746-22114-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.12.10 06:49:04, Robert Richter wrote:
> (resending due to mail corruption)
> 
> This patch set adds support for AMD family 15h systems. It adds cpu
> detection code for family 15h and implements support for 6 counters.
> 
> Suravee already sent updates for the oprofile userland to the oprofile
> mailing list.
> 
> Please review. If the patches are fine I will apply them to the
> oprofile git repostitory on kernel.org.

I applied the patches to

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

