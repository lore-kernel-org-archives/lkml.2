Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1KOCa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:30:29 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48517 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab1KOCaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:30:24 -0500
Message-ID: <4EC1CEAF.3040308@in.ibm.com>
Date: Tue, 15 Nov 2011 08:00:07 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Josh Boyer <jwboyer@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/44x: Fix typos '47x' and 'CONFIG_47x'
References: <1321309827.20271.146.camel@x61.thuisdomein>
In-Reply-To: <1321309827.20271.146.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11111416-5140-0000-0000-0000003D665E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/11 04:00, Paul Bolle wrote:
> Commit 674bfa4855 ("powerpc/44x: Kexec support for PPC440X chipsets")
> used the Kconfig symbol '47x', and the macro 'CONFIG_47x'. Neither
> exist. These should have been 'PPC_47x' and 'CONFIG_PPC_47x'. Fix these
> typos.

Thanks for catching this. I have already sent a series which fixes the
same. (Sub: Kdump support for PPC440x ). But I think I missed one hunk in
the misc_32.S.

>
> Also fix a related preprocessor check at the top of kexec.h.
>

Thanks

Suzuki

