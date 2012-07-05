Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2GEI2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:28:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab2GEI2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:28:13 -0400
Message-ID: <1341476877.7709.0.camel@twins>
Subject: Re: [PATCH] perf: add /proc/perf_events file for dump perf events
 info
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 05 Jul 2012 10:27:57 +0200
In-Reply-To: <CACV3sbLSzPoYYFJky=sFpca4L2gKdoOoEySn+mVHh1aphQLkyw@mail.gmail.com>
References: <CACV3sbLSzPoYYFJky=sFpca4L2gKdoOoEySn+mVHh1aphQLkyw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 16:23 +0800, Jovi Zhang wrote:
> This new /proc/perf_events file is used for real time dump all
> perf events info in whole system wide machine, this patch also add
> a new field perf_entry in struct perf_event, for connect to
> global list perf_events_list. 

This fails to mention why you'd want something like that.
