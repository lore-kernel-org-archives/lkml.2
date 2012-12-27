Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2L0QGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 11:06:09 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:64000 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab2L0QGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 11:06:07 -0500
Date: Thu, 27 Dec 2012 16:06:05 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, Paul Hargrove <phhargrove@lbl.gov>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: assign refcount for kmalloc_caches
In-Reply-To: <1356449082-3016-1-git-send-email-js1304@gmail.com>
Message-ID: <0000013bdd1d06aa-03085f43-6fa4-41dd-86aa-f0bf152e2851-000000@email.amazonses.com>
References: <CAAvDA15U=KCOujRYA5k3YkvC9Z=E6fcG5hopPUJNgULYj_MAJw@mail.gmail.com> <1356449082-3016-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012, Joonsoo Kim wrote:

> This patch assign initial refcount 1 to kmalloc_caches, so fix this
> errornous situtation.

Ok Only for 3.7:

Acked-by: Christoph Lameter <cl@linux.com>

