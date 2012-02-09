Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2BIBqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:46:19 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2BIBqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:46:17 -0500
Date: Wed, 8 Feb 2012 17:46:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] sysrq: Properly check for kernel threads
In-Reply-To: <20120207064951.GB1496@oksana.dev.rtsoft.ru>
Message-ID: <alpine.DEB.2.00.1202081745590.31205@chino.kir.corp.google.com>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru> <20120207064951.GB1496@oksana.dev.rtsoft.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012, Anton Vorontsov wrote:

> There's a real possibility of killing kernel threads that might
> have issued use_mm(), so kthread's mm might become non-NULL.
> 
> This patch fixes the issue by checking for PF_KTHREAD (just as
> get_task_mm()).
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: David Rientjes <rientjes@google.com>

Definitely needed.
