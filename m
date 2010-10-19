Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0JSOlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:41:36 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:41423 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752322Ab0JSOlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:41:35 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .1uoFWMVM1lH5XlTUi7R8afenRjiYYmey78uYZS_kde4NVP
 m6gEdK2WMwpxwHKAn3UFsbZ59qb84pXqEp7AtmCrzaowAxM6bqMSRypJN1EI
 qrTOG_6ZC96jCIWZ4.Rc_HBf2OWbo.7O4gzip1AZ_I9Z0rvFdPt9UP3iging
 iPNKx01HkSWssWV25RJV65RTwGuSVSXhtu_IHGycdDl4GHy27OUc6WnuAVSG
 GNKQoL87RuR4fL8r.72rG9KMY8BgooF146s9aWQ--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 19 Oct 2010 09:41:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [resend][PATCH 2/2] mm, mem-hotplug: update pcp->stat_threshold
 when memory hotplug occur
In-Reply-To: <20101019140955.A1EE.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010190941160.29434@router.home>
References: <20101019140831.A1EB.A69D9226@jp.fujitsu.com> <20101019140955.A1EE.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, KOSAKI Motohiro wrote:

> Currently, cpu hotplug updates pcp->stat_threashold, but memory
> hotplug doesn't. there is no reason.

Acked-by: Christoph Lameter <cl@linux.com>
