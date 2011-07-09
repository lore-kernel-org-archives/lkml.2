Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1GII1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 04:27:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45109 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1GII13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 04:27:29 -0400
Date: Sat, 9 Jul 2011 10:27:25 +0200
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Vmware balloon: switch to using sysem-wide freezable
 workqueue
Message-ID: <20110709082725.GA943@htj.dyndns.org>
References: <20110708211712.GA20258@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708211712.GA20258@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 02:17:12PM -0700, Dmitry Torokhov wrote:
> With the arrival of concurrency-managed workqueues there is no need
> for our driver to use dedicated workqueue; system-wide one should
> suffice just fine.
> 
> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
