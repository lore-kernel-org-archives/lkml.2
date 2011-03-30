Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1C3CRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:17:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1C3CRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:17:24 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=Dy6lNEr7fF0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=sozttTNsAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=kVBHvdNxE2I5NeSk4SUA:9 a=bjkSr7gosLDmRXtrFphNvNFMs28A:4 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=x2szoZtqnggA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG] NULL pointer dereference in dev_get_drvdata
From: Steven Rostedt <rostedt@goodmis.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <4D928E9D.8070202@redhat.com>
References: <1301448497.14261.319.camel@gandalf.stny.rr.com>
	 <4D928E9D.8070202@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 29 Mar 2011 22:17:22 -0400
Message-ID: <1301451442.14261.330.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 22:59 -0300, Mauro Carvalho Chehab wrote:

> Thanks for reporting it.
> 
> There were a change at ST interface, affecting this new driver.
> 
> I'm updating the fix today to -next:
> 
> commit f3149c7d9d989796306c6e65afbf4e89b3f81436
> Author: Manjunatha Halli <manjunatha_halli@ti.com>
> Date:   Wed Mar 23 07:44:30 2011 -0300
> 
>     [media] radio: wl128x: Update registration process with ST
>     
>     As underlying ST driver registration API's have changed with
>     latest 2.6.38-rc8 kernel this patch will update the FM driver
>     accordingly.
>     
>     Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> It is already on my tree:
> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
> 
> It should be available soon at kernel.org mirrors.

Are you sure you pushed it? I just ssh'd to kernel.org, went to your
directory and got:

$ cd /pub/scm/linux/kernel/git/mchehab/linux-next.git
$ git show f3149c7d9d989796306c6e65afbf4e89b3f81436
fatal: bad object f3149c7d9d989796306c6e65afbf4e89b3f81436

-- Steve

> 
> Could you please test it?


