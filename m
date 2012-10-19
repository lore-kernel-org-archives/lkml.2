Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab2JSKiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:38:24 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47310 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758649Ab2JSKiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:38:23 -0400
Message-ID: <50812D97.9060004@parallels.com>
Date: Fri, 19 Oct 2012 14:38:15 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 0/3] move slabinfo processing to common code
References: <1348844608-12568-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1348844608-12568-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 07:03 PM, Glauber Costa wrote:
> Hi,
> 
> This patch moves on with the slab caches commonization, by moving
> the slabinfo processing to common code in slab_common.c. It only touches
> slub and slab, since slob doesn't create that file, which is protected
> by a Kconfig switch.
> 
> Enjoy,
> 
> v2: return objects per slab and cache order in slabinfo structure as well
> 
Hi

Any activity here ?

