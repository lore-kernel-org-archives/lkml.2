Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2EYWgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:36:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45619 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2EYWgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:36:48 -0400
Date: Sat, 26 May 2012 00:36:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
Message-ID: <20120525223646.GL27374@one.firstfloor.org>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 11:16:08PM +0200, Jiri Olsa wrote:
> hi,
> adding support for creating event groups based on the way they
> are specified on the command line. 

Any updates on this patchkit? We have a situation here where better 
group management is needed to avoid problems with inconsistent
counters that depend on each others.

I don't see it in tip.

-Andi
