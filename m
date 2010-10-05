Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab0JEFca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:32:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56909 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab0JEFc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:32:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web servers
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Rob Mueller <robm@fastmail.fm>, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1010040805500.2502@router.home>
References: <20101004211112.E8B1.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1010040805500.2502@router.home>
Message-Id: <20101005142527.28DB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  5 Oct 2010 14:32:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 4 Oct 2010, KOSAKI Motohiro wrote:
> 
> > > The problem with zone reclaim mainly is created for large apps whose
> > > working set is larger than the local node. The special settings are only
> > > needing for those applications.
> >
> > In theory, yes. but please talk with userland developers. They always say
> > "Our software work fine on *BSD, Solaris, Mac, etc etc. that's definitely
> > linux problem". /me have no way to persuade them ;-)
> 
> Do those support NUMA? I would think not. You would have to switch on
> interleave at the BIOS level (getting a hardware hack in place to get
> rid of the NUMA effects) to make these OSes run right.

Sure. It wouldn't. Many opensource userland developers don't like
using out of posix API. In the other hand, many proprietery developers
don't hesitate it. I don't know reason.
Also, I'm not sure evey Corei7 Motherboard have BIOS level numa interleaving.
Are you sure? generically, commodity component vendor don't like to equipe 
additonal firmware feature. It's not zero cost. I think this solusion only fit
server vendor (e.g. IBM, HP, Fujitsu). but dunnno. Myself and fujitsu haven't hit 
this issue. I don't know _every_ motherboard equipement in the world.



