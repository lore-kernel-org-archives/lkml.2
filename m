Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325Ab1KCBft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:35:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab1KCBfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:35:45 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=DJOu6W8zkUMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5FU6YOvGAudmEMIC_skA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320284142.12443.0.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Restore system filter behavior
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 Nov 2011 21:35:42 -0400
In-Reply-To: <4EB1ED9F.3060708@cn.fujitsu.com>
References: <4EAF46CF.8040408@cn.fujitsu.com>
		 <1320258167.4793.45.camel@gandalf.stny.rr.com>
		 <1320259868.4793.46.camel@gandalf.stny.rr.com>
	 <1320266741.4793.50.camel@gandalf.stny.rr.com>
	 <4EB1ED9F.3060708@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 09:25 +0800, Li Zefan wrote:
>  
> > -	replace_filter_string(filter, filter_string);
> > +	/* System filters just show a default message */
> > +	replace_filter_string(filter, DEFAULT_SYS_FILTER_MESSAGE);
> 
> Seems we can call remove_filter_string() instead to save memory.

I originally had it that way, but for some reason I had to change it.
Not sure why. I'll put it back and see if that reason pops up again ;)

Thanks,

-- Steve


