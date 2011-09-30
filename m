Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab1I3UN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:13:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61434 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab1I3UN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:13:57 -0400
Date: Sat, 1 Oct 2011 00:12:56 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm00@gmail.com>
Cc: kernel-hardening@lists.openwall.com,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
Message-ID: <20110930201256.GB5173@albatros>
References: <20110927175453.GA3393@albatros>
 <20110927175642.GA3432@albatros>
 <20110927193810.GA5416@albatros>
 <20110928144614.38591e97.akpm00@gmail.com>
 <20110930195329.GA2020@albatros>
 <20110930130353.0da54517.akpm00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930130353.0da54517.akpm00@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 13:03 -0700, Andrew Morton wrote:
> meminfo has been around for a very long time and is a convenient and
> centralised point for collecting memory data.  There will be a large
> number of apps/scripts/tools out there which use it.  Many of these
> won't even be available to us.
> 
> All of which makes it very hard for us to predict how much breakage we
> will cause.
> 
> > If we care about (2), we should pass non-zero counters, but imagine some
> > default values, which will result in sane processes numbers.  But it
> > might depend on specific applications, I'm not aware whether (2) is
> > real.
> > 
> > 
> > Other ideas?
> 
> echo "chmod 0400 /proc/meminfo" >> /etc/rc.local

How will it help to fix apps' dependencies on meminfo?

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
