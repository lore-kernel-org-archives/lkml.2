Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab2HXQM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:12:59 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:21394 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759715Ab2HXQM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:12:57 -0400
Date: Fri, 24 Aug 2012 16:12:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/2] slub: rename cpu_partial to max_cpu_object
In-Reply-To: <1345824303-30292-1-git-send-email-js1304@gmail.com>
Message-ID: <0000013959685cfc-8f8f9570-98ba-4dd5-b2a5-25faba405d79-000000@email.amazonses.com>
References: <Yes> <1345824303-30292-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012, Joonsoo Kim wrote:

> cpu_partial of kmem_cache struct is a bit awkward.

Acked-by: Christoph Lameter <cl@linux.com>
