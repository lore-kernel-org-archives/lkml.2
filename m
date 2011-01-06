Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1AFIPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:15:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18533 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1AFIPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:15:22 -0500
Message-ID: <4D2579F1.50900@oracle.com>
Date: Thu, 06 Jan 2011 16:14:41 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gurudas.pai@oracle.com" <gurudas.pai@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        "guru.anbalagane@oracle.com" <guru.anbalagane@oracle.com>
Subject: Re: [patch] xenfb: fix xenfb suspend/resume race
References: <20101230125616.GA31537@joejin-pc.cn.oracle.com>	 <20101230164051.GC24313@dumpdata.com>	 <1294139733.3831.141.camel@zakaz.uk.xensource.com>	 <4D256BC7.1080501@oracle.com> <1294300924.13733.42.camel@localhost.localdomain>
In-Reply-To: <1294300924.13733.42.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> No, it papers over the issue, the code should never have been allowed to
> get this far if the connection to the backend is not yet fully resumed
> (i.e. when irq == -1).
> 
> The call to xenfb_send_event should have been gated further up the call
> chain, AFAICT by the check of info->update_wanted in xenfb_refresh. This
> suggests that the correct fix is to set info->update_wanted = 0 in
> xenfb_resume.
> 
> I said all this in my previous mail and you ignored it. Did you try this
> approach?

Will try this then update you.

Thanks,
Joe
