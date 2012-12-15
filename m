Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976Ab2LOGAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:00:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2LOGAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:00:30 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=h4cvScGyVGUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xAeIa9M__c8A:10 a=Z4Rwk6OoAAAA:8 a=voM4FWlXAAAA:8 a=D19gQVrFAAAA:8 a=cjNd3aqyD7T6DcEl4GMA:9 a=PUjeQqilurYA:10 a=jbrJJM5MRmoA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355551227.17101.411.camel@gandalf.local.home>
Subject: Re: mmotm 2012-12-14-17-51 uploaded (staging/sb105x)
From: Steven Rostedt <rostedt@goodmis.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-next@vger.kernel.org
Date: Sat, 15 Dec 2012 01:00:27 -0500
In-Reply-To: <50CC0AC4.3080206@infradead.org>
References: <20121215015227.144C820004E@hpza10.eem.corp.google.com>
	 <50CC0AC4.3080206@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-14 at 21:29 -0800, Randy Dunlap wrote:
> On 12/14/12 17:52, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2012-12-14-17-51 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> > 
> 
> 
> (not from mmotm patches)
> 
> When CONFIG_PARPORT is not enabled:
> 
> drivers/built-in.o: In function `multi_init':
> sb_pci_mp.c:(.init.text+0x162ac): undefined reference to `parport_pc_probe_port'
> 

I sent out a fix today. Thanks,

https://lkml.org/lkml/2012/12/14/250

-- Steve


