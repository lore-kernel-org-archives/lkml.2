Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0EERec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:34:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54957 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab0EEReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:34:31 -0400
Date: Wed, 5 May 2010 18:33:37 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505173337.GA1671@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <201005042223.41370.rjw@sisk.pl> <20100504235644.GA5231@opensource.wolfsonmicro.com> <201005050222.31038.rjw@sisk.pl> <20100505110630.GA5754@opensource.wolfsonmicro.com> <j2xa55d774e1005050500ocaa77b0di8e9eb58ce9c82d58@mail.gmail.com> <20100505135621.GB7139@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505135621.GB7139@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 02:56:22PM +0100, Mark Brown wrote:

> If the conclusion is that we don't have anything generic within the
> kernel then it'd be good to at least have this explicitly spelled out so
> that we're clear what everyone thinks is going on here and how things
> are supposed to work.  At the minute it doesn't feel like we've had the
> discussion so we could end up working at cross purposes.  I don't want
> to end up in the situation where I have to work around the APIs I'm
> using without the relevant maintainers having sight of that since that
> not only am I likely to be missing some existing solution to the problem
> but is also prone to causing problems maintaining the underlying API.

We seem to have ended up managing most of our PM infrastructure 
iteratively. If the concern is more about best practices than intrinsic 
incompatibilities, I'd lean towards us being better off merging this now 
and then working things out over the next few releases as we get a 
better understanding of the implications. The main thing that we have to 
get right in the short term is the userspace API - everything else is 
easier to fix up as we go along.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
