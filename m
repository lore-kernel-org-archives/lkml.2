Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1HECJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 22:09:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab1HECJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 22:09:16 -0400
Date: Thu, 4 Aug 2011 22:09:13 -0400
From: Dave Jones <davej@redhat.com>
To: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Nguyen, Tom L" <tom.l.nguyen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [rfc] suppress excessive AER output
Message-ID: <20110805020913.GC19434@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Zhang, Yanmin" <yanmin.zhang@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Nguyen, Tom L" <tom.l.nguyen@intel.com>,
	"Huang, Ying" <ying.huang@intel.com>
References: <20110803223407.GA20646@redhat.com>
 <33AB447FBD802F4E932063B962385B3512D9615780@shsmsx501.ccr.corp.intel.com>
 <20110805015008.GA19434@redhat.com>
 <33AB447FBD802F4E932063B962385B3512D9615B4D@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33AB447FBD802F4E932063B962385B3512D9615B4D@shsmsx501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 09:59:39AM +0800, Zhang, Yanmin wrote:
 > Dave,
 > 
 > My idea is application has opportunity to reset it. Consider the critical mission environment, admin could hot-unplug any failed devices without rebooting system. Then, admin doesn't want to lose AER monitoring.
 > 
 > With the module parameter, admin could change it under /sys/module/aer_drv/parameters.
 
ah, I see. Yes, that sounds sensible.

	Dave.
 
