Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2JVOoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:44:24 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:47230 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab2JVOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:44:23 -0400
Date: Mon, 22 Oct 2012 14:44:22 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] slab: commonize slab_cache field in struct page
In-Reply-To: <1350914737-4097-2-git-send-email-glommer@parallels.com>
Message-ID: <0000013a88ee7ed0-50126a71-b26c-4a32-add4-82965a795578-000000@email.amazonses.com>
References: <1350914737-4097-1-git-send-email-glommer@parallels.com> <1350914737-4097-2-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Glauber Costa wrote:

> The naming used by slab, "slab_cache", is less confusing, and it is
> preferred over slub's generic "slab".

Acked-by: Christoph Lameter <cl@linux.com>
