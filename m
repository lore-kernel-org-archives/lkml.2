Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1AUDMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:12:43 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:55845 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1AUDMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:12:41 -0500
Date: Thu, 20 Jan 2011 22:12:39 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Message-ID: <1949676939.98607.1295579559013.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1607793457.82870.1295506273461.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: ksm/thp/memcg bug
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Or apply pathces I sent ? (As Nishimura-san pointed out.)
> I'll try them.
After applied those patches, the problem goes away.
