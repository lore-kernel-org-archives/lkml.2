Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0I1Mtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:49:45 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:28264 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753576Ab0I1Mtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:49:45 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Rpb81JIVM1l9k2EouXvVOn3U2oTLFLAxgHRnuV8.UXG8313
 ccxzzGWFuYl2HYWe_zLcJK5HG02kAlpFHKrVnSU.JiFZa9WA0rw3XQr_ssZq
 jjObVkKyVG9MhlWOhDQr6RrkrwR31TxpXrr4G8v5dwTAcosfqtamLj5g9gQH
 hPYCw7iKbS6ihLDWaQI6.r74ZQ9uanjwcfBWGnCOV2z_6FZJDWHECnDxutC8
 kWVUvKJIhhs6SeunQ2ad22lRw3CEX
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 28 Sep 2010 07:49:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Bron Gondwana <brong@fastmail.fm>
cc: Robert Mueller <robm@fastmail.fm>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web
 servers
In-Reply-To: <1285677740.30176.1397281937@webmail.messagingengine.com>
Message-ID: <alpine.DEB.2.00.1009280748590.4144@router.home>
References: <52C8765522A740A4A5C027E8FDFFDFE3@jem> <20100921090407.GA11439@csn.ul.ie> <20100927110049.6B31.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009270828510.7000@router.home> <1285629420.10278.1397188599@webmail.messagingengine.com>
 <alpine.DEB.2.00.1009280727370.4144@router.home> <1285677740.30176.1397281937@webmail.messagingengine.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010, Bron Gondwana wrote:

> Is this what's happening, or is IO actually coming from disk in preference
> to the remote node?  I can certainly see the logic behind preferring to
> reclaim the local node if that's all that's happening - though the OS should
> be allocating the different tasks more evenly across the nodes in that case.

Not sure about the disk. I did not see anything that would indicate and
issue with only being able to do 32 bit and I am no expert on the device
driver operations.

