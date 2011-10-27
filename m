Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1J0Rfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 13:35:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27279 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1J0Rfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 13:35:42 -0400
Date: Thu, 27 Oct 2011 13:35:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: Regression: patch " hvc_console: display printk messages on
 console." causing infinite loop with 3.2-rc0 + Xen.
Message-ID: <20111027173527.GA23839@phenom.dumpdata.com>
References: <20111027053007.GA32765@phenom.dumpdata.com>
 <20111027054806.GA1377@suse.de>
 <CAB8Rdaq2r4Uc-WZK-k=wiEW8DKdixn+9dB7E4_XDL7k8jCMwSw@mail.gmail.com>
 <20111027150826.GC1157@phenom.dumpdata.com>
 <20111027153132.GA2751@phenom.dumpdata.com>
 <CAB8RdarECbYFuuD7-Jz_o5kC3aBd5JAASB76B=ZioYo2-sjPfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB8RdarECbYFuuD7-Jz_o5kC3aBd5JAASB76B=ZioYo2-sjPfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EA99668.000C:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 10:22:21AM -0700, Miche Baker-Harvey wrote:
> Konrad,
> 
> This looks similar to something I was seeing before I added some
> locking and multi-hvc console support.
> I think what's happening is that once the console is enabled, the
> first line in printk's console buffer is
> being infinitely printed.  Would you be willing to try another patch?

Sure.
> I'm pulling the patch into Linus'
> latest now...

OK. Just send it to me and I will try it out.
