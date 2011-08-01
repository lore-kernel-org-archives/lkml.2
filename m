Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1HAQUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:20:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44029 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1HAQUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:20:08 -0400
Date: Mon, 1 Aug 2011 18:20:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3] oprofile, x86: Convert memory allocation to static array
Message-ID: <20110801162007.GB27083@one.firstfloor.org>
References: <4E35A14E.90702@gmail.com> <20110801070742.GA11795@erda.amd.com> <4E36C18B.7050502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E36C18B.7050502@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 05:08:59PM +0200, Maarten Lankhorst wrote:
> On -rt, allocators don't work from atomic context any more,
> and the maximum size of the array is known at compile time.

What!?! Can you please fix -rt instead? That sounds very broken.

-Andi
