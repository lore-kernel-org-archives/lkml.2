Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2ECMrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:47:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38926 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2ECMrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:47:17 -0400
Date: Thu, 3 May 2012 13:47:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Adrian Fita <adrian.fita@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Ralf Jung <ralfjung-e@gmx.de>, Paolo Scarabelli <paolo@msw.it>
Subject: Re: [bug?] Battery notifications produce flashing battery icon,
 syslog spam (Re: [PATCH 11/11] ACPI / Battery: Update information on info
 notification and resume)
Message-ID: <20120503124708.GA18622@srcf.ucam.org>
References: <201101062331.17079.rjw@sisk.pl>
 <201101062342.28168.rjw@sisk.pl>
 <20120501184534.GA31731@burratino>
 <4FA032EA.1090608@gmail.com>
 <20120501191408.GD19143@burratino>
 <20120503085458.GG3364@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503085458.GG3364@shadowen.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:54:58AM +0100, Andy Whitcroft wrote:
> 
> From the description of the change this is necessary because the
> capacity units may change over time?  Can we not use those to avoid this
> update?  I presume it is these two we are referring to?
> 
>         int capacity_granularity_1;
>         int capacity_granularity_2;

power_unit rather than capacity_granularity, but the idea seems solid.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
