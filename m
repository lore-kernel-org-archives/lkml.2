Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2IJQel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:34:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38874 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2IJQek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:34:40 -0400
Message-ID: <1347294866.2124.28.camel@twins>
Subject: Re: [RFC PATCH 1/3] perf: Add cpumask for uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@elte.hu, andi@firstfloor.org, jolsa@redhat.com,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Mon, 10 Sep 2012 18:34:26 +0200
In-Reply-To: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 15:53 +0800, Yan, Zheng wrote:
> Hi,
> 
> This patchset add a cpumask file to the uncore pmu sysfs directory.
> If user doesn't explicitly specify CPU list, perf-stat only collects
> uncore events on CPUs listed in the cpumask file.
> 
> As Stephane suggested, make perf-stat recognize wildcard in pmu name.
> So we can easily measure event on all uncore boxes of same type.
> 	
> Any comment is appreciated.

You forgot to CC acme who maintains the tools side.. Anyway, I think it
all looks ok, Arnaldo see anything dubious in there?
