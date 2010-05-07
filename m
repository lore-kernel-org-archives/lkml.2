Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab0EGU3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:29:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39489 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0EGU3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:29:31 -0400
Date: Fri, 7 May 2010 21:28:59 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507202859.GA27328@srcf.ucam.org>
References: <20100507173549.GF387@atomide.com> <20100507175025.GA23952@srcf.ucam.org> <20100507180152.GH387@atomide.com> <20100507182824.GA25198@srcf.ucam.org> <20100507184333.GL387@atomide.com> <20100507184621.GA25978@srcf.ucam.org> <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com> <20100507192837.GM387@atomide.com> <20100507193353.GA27175@srcf.ucam.org> <20100507195548.GN387@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507195548.GN387@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 12:55:48PM -0700, Tony Lindgren wrote:

> - Deal with broken apps whichever way you want in the userspace.

If we could do this then there would be no real need for suspend 
blockers.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
