Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2BXEgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:36:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:42453 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2BXEgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:36:31 -0500
Date: Thu, 23 Feb 2012 23:33:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #42683] WARN... Device 'cpu1' does not have a release()
 function, it is broken and must be fixed. when doing 'xl vcpu-set <guest_id>
 1'
Message-ID: <20120224043300.GB23568@phenom.dumpdata.com>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
 <qCQH7HfZS8E.A.AHG.E9rRPB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qCQH7HfZS8E.A.AHG.E9rRPB@chimera>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F4713C9.0057,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 11:55:57PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 3.2.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42683
> Subject		: WARN... Device 'cpu1' does not have a release() function, it is broken and must be fixed. when doing 'xl vcpu-set <guest_id> 1'
> Submitter	: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date		: 2012-01-23 18:06 (32 days old)
> Message-ID	: <20120123180601.GA24553@phenom.dumpdata.com>
> References	: http://marc.info/?l=linux-kernel&m=132734233916154&w=2

Fixed.
