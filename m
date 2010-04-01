Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0DADcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:32:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:59628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0DADcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:32:41 -0400
Message-ID: <4BB41372.3060808@kernel.org>
Date: Wed, 31 Mar 2010 20:30:58 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v3] nobootmem/bootmem, x86: Fix 32bit numa system without
 RAM on Node0
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <4BB3C739.2020106@kernel.org> <20100331221341.GA20441@elte.hu> <4BB3C9B0.4000205@kernel.org> <20100331224108.GA11284@elte.hu> <4BB3D0F4.902@kernel.org> <4BB3DC23.50005@zytor.com> <4BB3E0CA.5060405@kernel.org> <4BB3EA55.50505@zytor.com> <4BB3FEA6.8030309@kernel.org> <ca9eedfe-479e-4ccf-9663-66afcd2bbd69@email.android.com>
In-Reply-To: <ca9eedfe-479e-4ccf-9663-66afcd2bbd69@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 08:18 PM, H. Peter Anvin wrote:
> Please address the separate bug fix in a separate patch.

ok.
