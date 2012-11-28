Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2K1Avw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:51:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab2K1Avv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:51:51 -0500
Date: Tue, 27 Nov 2012 22:32:29 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com
Subject: Re: [PATCH 0/5] Alter steal time reporting in KVM
Message-ID: <20121128003229.GE8295@amt.cnet>
References: <20121126203603.28840.38736.stgit@lambeau>
 <20121127232442.GA8295@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127232442.GA8295@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 09:24:42PM -0200, Marcelo Tosatti wrote:
> On Mon, Nov 26, 2012 at 02:36:24PM -0600, Michael Wolf wrote:
> > In the case of where you have a system that is running in a
> > capped or overcommitted environment the user may see steal time
> > being reported in accounting tools such as top or vmstat.
> 
> The definition of stolen time is 'time during which the virtual CPU is
> runnable to not running'. Overcommit is the main scenario which steal
> time helps to detect.

Meant 'runnable but not running'.


> Can you describe the 'capped' case?

