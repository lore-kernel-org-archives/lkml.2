Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1JYH0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:26:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33618 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1JYH0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:26:33 -0400
Subject: Re: [RFC PATCH 1/2] tools/perf: Don't set attr->disabled when
 doing grouping
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Ahern <dsahern@gmail.com>
Cc: Deng-Cheng Zhu <dczhu@mips.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <4EA573E4.3090408@gmail.com>
References: <1319453820-12992-1-git-send-email-dczhu@mips.com>
	 <1319453820-12992-2-git-send-email-dczhu@mips.com>
	 <4EA573E4.3090408@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 09:26:23 +0200
Message-ID: <1319527583.13128.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-24 at 08:19 -0600, David Ahern wrote:
> 
> Seems like a bug with the group checks. You should be able to enable and
> disable events - including creating them disabled.

Agreed, it makes no sense to allow creating a group you can't use.

