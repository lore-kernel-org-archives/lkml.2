Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2KIUND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:13:03 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:46739 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369Ab2KIUNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:13:00 -0500
Date: Fri, 9 Nov 2012 20:12:59 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: jesse@nicira.com, dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 4/9] net: openvswitch: use this_cpu_ptr per-cpu
 helper
In-Reply-To: <509C6895.6020300@gmail.com>
Message-ID: <0000013ae6cdd300-d1d2139d-de84-4c27-99f1-e54592e23aba-000000@email.amazonses.com>
References: <509C6895.6020300@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Shan Wei wrote:

> just use more faster this_cpu_ptr instead of per_cpu_ptr(p, smp_processor_id());

Reviewed-by: Christoph Lameter <cl@linux.com>
