Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab2FYRRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:17:12 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:31259 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2FYRRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:17:11 -0400
Message-ID: <1340644628.6882.3.camel@lorien2>
Subject: Re: [tip:x86/cleanups] x86/early_printk: Replace obsolete
 simple_strtoul() usage with kstrtoint()
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Ingo Molnar <mingo@kernel.org>
Cc: shuahkhan@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Date: Mon, 25 Jun 2012 11:17:08 -0600
In-Reply-To: <20120622142456.GA24850@gmail.com>
References: <1338424803.3569.5.camel@lorien2>
	 <tip-fbd24153c48b8425b09c161a020483cd77da870e@git.kernel.org>
	 <20120622142456.GA24850@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I'm dropping this patch.

No problem. I missed return value check in one path. Will fix it and
send the fixed patch. I probably will pool this change with other
simple_strtoul() cleanup related changes I am working on.

-- Shuah

