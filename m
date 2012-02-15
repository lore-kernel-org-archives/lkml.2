Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab2BONj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:39:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:40760 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab2BONj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:39:28 -0500
Message-ID: <1329313162.2293.107.camel@twins>
Subject: Re: [PATCHv4 0/9] perf tool: parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Date: Wed, 15 Feb 2012 14:39:22 +0100
In-Reply-To: <20120215133218.GD1664@m.brq.redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
	 <1329236924.2293.13.camel@twins> <1329237838.2293.20.camel@twins>
	 <1329250830.2293.24.camel@twins> <1329253030.2293.27.camel@twins>
	 <1329253391.2293.31.camel@twins> <20120215092423.GB1664@m.brq.redhat.com>
	 <1329304712.2293.46.camel@twins> <20120215133218.GD1664@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 14:32 +0100, Jiri Olsa wrote:
> also, any idea when's the branch_sample_type going in?

any day now, I've queued it and will see if it compiles runs in a bit
after which I'll try and throw it over the wall to mingo.
