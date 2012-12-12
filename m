Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2LLUIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:08:15 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:59780 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629Ab2LLUIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:08:14 -0500
Date: Wed, 12 Dec 2012 20:08:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joe Perches <joe@perches.com>
cc: Jiri Kosina <trivial@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH 23/26] mm: Convert print_symbol to %pSR
In-Reply-To: <96a83ddb7f8571afe8b3b3b6e7fc9dc3ff81dda5.1355335228.git.joe@perches.com>
Message-ID: <0000013b90bb4f41-3c381041-b26d-4534-b983-a025858bb748-000000@email.amazonses.com>
References: <cover.1355335227.git.joe@perches.com> <96a83ddb7f8571afe8b3b3b6e7fc9dc3ff81dda5.1355335228.git.joe@perches.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2012, Joe Perches wrote:

> Use the new vsprintf extension to avoid any possible
> message interleaving.

Acked-by: Christoph Lameter <cl@linux.com>

