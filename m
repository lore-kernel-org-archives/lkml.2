Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1AUDVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:21:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48267 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1AUDVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:21:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Jan 2011 12:15:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: CAI Qian <caiqian@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: ksm/thp/memcg bug
Message-Id: <20110121121524.b7957dce.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1949676939.98607.1295579559013.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References: <1607793457.82870.1295506273461.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<1949676939.98607.1295579559013.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 22:12:39 -0500 (EST)
CAI Qian <caiqian@redhat.com> wrote:

> 
> > > Or apply pathces I sent ? (As Nishimura-san pointed out.)
> > I'll try them.
> After applied those patches, the problem goes away.
> 

Great! thank you!

-Kame

