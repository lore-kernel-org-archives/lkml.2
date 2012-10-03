Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2JCORv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:17:51 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:49815 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951Ab2JCORu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:17:50 -0400
Date: Wed, 3 Oct 2012 14:17:48 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jiri Kosina <jkosina@suse.cz>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] [RFC] mm, slab: release slab_mutex earlier in
 kmem_cache_destroy()
In-Reply-To: <alpine.LNX.2.00.1210031143260.23544@pobox.suse.cz>
Message-ID: <0000013a26fd59e5-1f226b01-0e73-4a02-b4a0-fe697b34457e-000000@email.amazonses.com>
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <20121002170149.GC2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210022324050.23544@pobox.suse.cz> <alpine.LNX.2.00.1210022331130.23544@pobox.suse.cz> <alpine.LNX.2.00.1210022356370.23544@pobox.suse.cz>
 <20121002233138.GD2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030142570.23544@pobox.suse.cz> <20121003001530.GF2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030227430.23544@pobox.suse.cz> <alpine.LNX.2.00.1210031143260.23544@pobox.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux.com>

