Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1HSPj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:39:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63534 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1HSPj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <1313766840.15704.104.camel@gandalf.stny.rr.com>
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
	<1313766840.15704.104.camel@gandalf.stny.rr.com>
Date: Fri, 19 Aug 2011 23:39:55 +0800
Message-ID: <CACVXFVNKe+gt2VmrHcJ2Pd1ZvqfOPn+211vR-PcM-WDTYDN4cQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] trace points: power: remove 'cpu_id' from trace_clock_*
From: Ming Lei <tom.leiming@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, jean.pihet@newoldbits.com, mingo@redhat.com,
        trenn@suse.de, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 19, 2011 at 11:14 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Do you know if these changes wont break powertop?

I have run powertop 1.13 on these changes, and found it works well
just like before,
no breaks found.

thanks,
-- 
Ming Lei
