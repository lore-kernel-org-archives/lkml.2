Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2BEPSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 10:18:50 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:49600 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2BEPSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 10:18:48 -0500
Message-ID: <4F2E9DC7.1070702@linux.vnet.ibm.com>
Date: Sun, 05 Feb 2012 20:48:31 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH v8 1/8] smp: introduce a generic on_each_cpu_mask function
References: <1328448800-15794-1-git-send-email-gilad@benyossef.com> <1328449499-15886-1-git-send-email-gilad@benyossef.com>
In-Reply-To: <1328449499-15886-1-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020515-8256-0000-0000-000001241BD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 07:14 PM, Gilad Ben-Yossef wrote:

> on_each_cpu_mask calls a function on processors specified by
> cpumask, which may or may not include the local processor.
> 
> You must not call this function with disabled interrupts or
> from a hardware interrupt handler or from a bottom half handler.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reviewed-by: Christoph Lameter <cl@linux.com>
> CC: Chris Metcalf <cmetcalf@tilera.com>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: linux-mm@kvack.org
> CC: Pekka Enberg <penberg@kernel.org>
> CC: Matt Mackall <mpm@selenic.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Sasha Levin <levinsasha928@gmail.com>
> CC: Mel Gorman <mel@csn.ul.ie>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Alexander Viro <viro@zeniv.linux.org.uk>
> CC: linux-fsdevel@vger.kernel.org
> CC: Avi Kivity <avi@redhat.com>
> CC: Michal Nazarewicz <mina86@mina86.com>
> CC: Kosaki Motohiro <kosaki.motohiro@gmail.com>
> CC: Milton Miller <miltonm@bga.com>
> ---


Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

