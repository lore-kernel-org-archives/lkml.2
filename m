Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1AQONe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:13:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46052 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1AQONd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:13:33 -0500
Subject: Re: [wake_afine fixes/improvements 2/3] sched: clean up task_hot()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20110115015817.160235155@google.com>
References: <20110115015749.692623529@google.com>
	 <20110115015817.160235155@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 15:14:04 +0100
Message-ID: <1295273644.30950.121.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 17:57 -0800, Paul Turner wrote:
> plain text document attachment (no_hot_sd.patch)
> We no longer compute per-domain migration costs or have use for task_hot()
> external to the fair scheduling class.

Ok, so this a mostly a pure code move (aside from removing the unused sd
argument). I do seem to remember that various folks played around with
bringing the per sd cache refill cost back.. any conclusion on that?

(not really a big point, we can easily add the argument back when
needed)
