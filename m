Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2KSVe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:34:59 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:60375 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab2KSVe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:34:58 -0500
Date: Mon, 19 Nov 2012 21:34:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace: use __this_cpu_inc/dec operation instead of
 __get_cpu_var
In-Reply-To: <50A9C1BD.1060308@gmail.com>
Message-ID: <0000013b1a987395-2afa8715-e3f8-4bd1-8f56-6a8073da757b-000000@email.amazonses.com>
References: <50A9C1BD.1060308@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012, Shan Wei wrote:

> __this_cpu_inc_return() or __this_cpu_dec generates a single instruction,
> which is faster than __get_cpu_var operation.

Reviewed-by: Christoph Lameter <cl@linux.com>
