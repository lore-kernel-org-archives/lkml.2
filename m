Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab2I1Q0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:26:34 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:53600 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758408Ab2I1Q0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:26:33 -0400
Date: Fri, 28 Sep 2012 16:26:31 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 3/3] sl[au]b: process slabinfo_show in common code
In-Reply-To: <1348844608-12568-4-git-send-email-glommer@parallels.com>
Message-ID: <0000013a0db36047-406edc2f-5adb-4e50-86ba-a398be3a43e1-000000@email.amazonses.com>
References: <1348844608-12568-1-git-send-email-glommer@parallels.com> <1348844608-12568-4-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Glauber Costa wrote:

> [ v2: moved objects_per_slab and cache_order to slabinfo ]

Acked-by: Christoph Lameter <cl@linux.com>
