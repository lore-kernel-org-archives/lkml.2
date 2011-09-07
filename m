Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab1IGQfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:35:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:38266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab1IGQdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:09 -0400
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        dsahern@gmail.com
Date: Wed, 07 Sep 2011 10:12:31 +0200
In-Reply-To: <20110906204637.GA31826@quad>
References: <20110906204637.GA31826@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315383151.11101.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-06 at 22:46 +0200, Stephane Eranian wrote:
> +static const char *topo_fmt[] = {
> +       "/sys/devices/system/cpu/cpu%d/topology/core_siblings_list",
> +       "/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list",
> +       NULL
> +}; 

No nodes?
