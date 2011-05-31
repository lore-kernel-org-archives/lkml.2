Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1EaMtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:49:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39299 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1EaMtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:49:08 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=mh_q4EFMtyMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KiueqiaNGVLnDfz0aTQA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Turning off the incremental diff robot
From: Steven Rostedt <rostedt@goodmis.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110531123811.GA2457@osiris.boeblingen.de.ibm.com>
References: <4DE3E9E7.8020008@zytor.com>
	 <20110530194500.GE10792@home.goodmis.org> <4DE402BD.4060407@zytor.com>
	 <20110531123811.GA2457@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 08:49:05 -0400
Message-ID: <1306846145.11899.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 14:38 +0200, Heiko Carstens wrote:

> > No, but it generates the patches between, say, 2.6.x.y and 2.6.x.y+1 or
> > 2.6.x-rcy and 2.6.x-rcy+1.  Anything in an "incr" directory.
> 
> Yep, I use those incremental patches over here.

And the ketchup utility does too. But that needs to be fixed as well.
Luckily I just handed over maintainership of ketchup to someone else :)

-- Steve


