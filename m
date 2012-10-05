Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2JETAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:00:14 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:59631 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab2JETAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:00:10 -0400
Date: Fri, 5 Oct 2012 19:00:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v4] slab: Ignore internal flags in cache creation
In-Reply-To: <1349434154-8000-1-git-send-email-glommer@parallels.com>
Message-ID: <0000013a324c8c9a-26b4f363-3799-40a9-843a-66dc79770170-000000@email.amazonses.com>
References: <1349434154-8000-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2012, Glauber Costa wrote:

> Common code will mask out all flags not belonging to that set.

Acked-by: Christoph Lameter <cl@linux.com>
