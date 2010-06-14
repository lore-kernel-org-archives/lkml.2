Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0FNGiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 02:38:15 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:51521 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab0FNGiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 02:38:14 -0400
Date: Mon, 14 Jun 2010 07:38:13 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
In-Reply-To: <4C158BCF.6000303@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1006140735040.11549@eddie.linux-mips.org>
References: <4C11FF10.4060203@jp.fujitsu.com> <4C11FFC0.1030006@jp.fujitsu.com> <4C1275BF.3070605@zytor.com> <4C158BCF.6000303@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, Kenji Kaneshige wrote:

> - Architectural limit of physical address in x86 32-bit mode is 40-bit
>   (depnds on processor version).

 According to documentation I happen to have handy this limit is actually 
52 bits (and space is currently available in the data structures used for 
a possible future extension up to 63 bits).

  Maciej
