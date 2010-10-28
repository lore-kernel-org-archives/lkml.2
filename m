Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0J1Ak5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:40:57 -0400
Received: from thunk.org ([69.25.196.29]:51541 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711Ab0J1Akx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:40:53 -0400
Date: Wed, 27 Oct 2010 20:40:47 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Perf can't deal with many tracepoints
Message-ID: <20101028004047.GH3194@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Daney <ddaney@caviumnetworks.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	linux-kernel@vger.kernel.org
References: <E1PBFIJ-0004eC-Tj@tytso-glaptop>
 <4CC8C0D2.7060304@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC8C0D2.7060304@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:16:18PM -0700, David Daney wrote:
> Tracing is supposed to be low overhead.  Forcing people to decode
> things like this at the trace point, may take more code and cause
> the trace data to be larger, making it slower than necessary.
> 
> If there isn't a good reason to keep perf stupid, then making it
> smarter could be attractive.

Agreed.  Although one argument against making perf smarter is that
certain things such as the dev_t MAJOR/MINOR split is an internal
abstraction that could potentially vary from kernel to kernel.

And the question is whether perf really should be so different that if
you boot a different kernel, you had better have the right perf
installed.

							- Ted
