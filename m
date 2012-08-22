Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab2HVSWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:22:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:40807 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100Ab2HVSWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:22:35 -0400
Message-ID: <1345659711.26596.7.camel@twins>
Subject: Re: [PATCH] perf: Keep the perf_event_attr on version 3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@kernel.org, eranian@google.com,
        gorcunov@openvz.org, benjamin.redelings@nescent.org,
        fweisbec@gmail.com, robert.richter@amd.com, drepper@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, asharma@fb.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com,
        mingo@elte.hu
Date: Wed, 22 Aug 2012 20:21:51 +0200
In-Reply-To: <20120822181834.GG7764@infradead.org>
References: <1344345647-11536-6-git-send-email-jolsa@redhat.com>
	 <tip-c5ebcedb566ef17bda7b02686e0d658a7bb42ee7@git.kernel.org>
	 <1345569116.26596.4.camel@twins>
	 <20120822083540.GB1003@krava.brq.redhat.com>
	 <20120822181834.GG7764@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 15:18 -0300, Arnaldo Carvalho de Melo wrote:
> I'm lazy so couldn't quickly find any problem in applying this patch,
> Peter, can you see any problem?
> 
> Will add your Acked-by if you can't. 

No its fine, thanks!
