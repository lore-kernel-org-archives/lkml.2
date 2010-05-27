Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab0E0OQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:16:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:56145 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab0E0OQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:16:12 -0400
Message-ID: <4BFE7EAC.9090408@suse.cz>
Date: Thu, 27 May 2010 16:16:12 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, matt mooney <mfm@muteddisk.com>,
       Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: linux-next: manual merge of the kbuild tree with the kernel-doc
 tree
References: <20100526115346.da5a02aa.sfr@canb.auug.org.au>	<4BFD42A6.6060206@oracle.com>	<20100527025020.da0c1bb7.sfr@canb.auug.org.au>	<20100526095606.beed820e.randy.dunlap@oracle.com>	<20100527090923.c17a7ed4.sfr@canb.auug.org.au>	<4BFDB60B.50106@oracle.com> <20100527110357.f295d4ef.sfr@canb.auug.org.au>
In-Reply-To: <20100527110357.f295d4ef.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.5.2010 03:03, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Wed, 26 May 2010 17:00:11 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> uh oh.  OK, thanks, I'll restore them.
> 
> Thanks.  I picked them up.

I reverted part of the kbuild patch so that the two trees merge cleanly
again.

Michal
