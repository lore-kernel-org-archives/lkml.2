Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0C2KuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:50:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41138 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab0C2KuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:50:11 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, MCE, fix MSR_IA32_MCI_CTL2 CMCI threshold setup
From: Andi Kleen <andi@firstfloor.org>
References: <1269847000.1060.91.camel@yhuang-dev.sh.intel.com>
	<4BB06426.7070707@jp.fujitsu.com>
Date: Mon, 29 Mar 2010 12:50:09 +0200
In-Reply-To: <4BB06426.7070707@jp.fujitsu.com> (Hidetoshi Seto's message of "Mon, 29 Mar 2010 17:26:14 +0900")
Message-ID: <87k4sv7672.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:
>
> Maybe we could handle this environment if kernel supports
> APEI's firmware-first for corrected MCE and if this is in
> that case.

The problem at hand has nothing to do with firmware first
or APEI.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
