Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0JAGXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:23:12 -0400
Received: from smtp.nokia.com ([147.243.1.47]:19289 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0JAGXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:23:08 -0400
Subject: Re: [PATCH 1/1] timer: permit statically-declared work with
 deferrable timers
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1285874789-1481-2-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1285874789-1481-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <1285874789-1481-2-git-send-email-ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 01 Oct 2010 09:19:33 +0300
Message-ID: <1285913973.11684.63.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 21:26 +0200, ext Phil Carmody wrote:
> Currently, you have to just define a delayed_work uninitialised, and then
> initialise it before first use. That's a tad clumsy. At risk of playing
> mind-games with the compiler, fooling it into doing pointer arithmetic
> with compile-time-constants, this lets clients properly initialise delayed
> work with deferrable timers statically.
> 
> This patch was inspired by the issues which lead Artem Bityutskiy
> to commit 8eab945c5616fc984e97b922d6a2559be93f39a1.
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Acked-by: Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

