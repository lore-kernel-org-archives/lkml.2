Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2IIV2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 17:28:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35719 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab2IIV17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 17:27:59 -0400
Date: Sun, 9 Sep 2012 14:27:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 02/10] mm, slob: Use NUMA_NO_NODE instead of -1
In-Reply-To: <1347137279-17568-2-git-send-email-elezegarcia@gmail.com>
Message-ID: <alpine.DEB.2.00.1209091427160.13346@chino.kir.corp.google.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com> <1347137279-17568-2-git-send-email-elezegarcia@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2012, Ezequiel Garcia wrote:

> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>

Please cc Matt Mackall <mpm@selenic.com> on all slob patches in the 
future.
