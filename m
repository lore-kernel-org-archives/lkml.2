Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1HAWDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 18:03:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35092 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1HAWDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 18:03:03 -0400
Subject: Re: [PATCH v3] oprofile, x86: Convert memory allocation to static
 array
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20110801213142.GE11795@erda.amd.com>
References: <4E35A14E.90702@gmail.com> <20110801070742.GA11795@erda.amd.com>
	 <4E36C18B.7050502@gmail.com>  <20110801213142.GE11795@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Aug 2011 00:02:20 +0200
Message-ID: <1312236140.1147.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 23:31 +0200, Robert Richter wrote:
> do you want this for 3.1 (perf/urgent) or 3.2?

No particular hurry on my side..
