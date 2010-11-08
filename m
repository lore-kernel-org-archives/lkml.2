Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0KHJ4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:56:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35158 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab0KHJ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:56:12 -0500
Date: Mon, 8 Nov 2010 04:56:10 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, chris@chris-wilson.co.uk,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Tracing: do export trace_set_clr_event
Message-ID: <20101108095610.GA22592@infradead.org>
References: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 02:05:12PM +0800, Yuanhan Liu wrote:
> Trace event belongs to a module does exist only when the module is
> loaded. Well, we can use trace_set_clr_event funtion to enable some
> trace event at the module init routine, so that we will not miss
> something while loading then module.
> 
> So, Export the trace_set_clr_event function so that module can use it.

Which module?

