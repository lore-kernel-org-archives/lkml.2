Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2LKOaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:30:05 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:44785 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472Ab2LKOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:30:04 -0500
Date: Tue, 11 Dec 2012 14:30:02 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>, glommer@parallels.com, js1304@gmail.com,
        linux-kernel@vger.kernel.org
Subject: signed size_t ?
In-Reply-To: <50c71402.BHvgqw/3pK2m2gAL%fengguang.wu@intel.com>
Message-ID: <0000013b8a5f57c0-442ea272-5d51-4870-af48-ed948a98b2ef-000000@email.amazonses.com>
References: <50c71402.BHvgqw/3pK2m2gAL%fengguang.wu@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012, kbuild test robot wrote:

> mm/slab_common.c: In function 'create_boot_cache':
> mm/slab_common.c:219:6: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]

We already changed that once from %td to %zd so that the size_t works
correctly.

Does a signed size_t make any sense?

