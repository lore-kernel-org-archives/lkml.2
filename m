Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab2JSWIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:08:12 -0400
Received: from mail-da0-f56.google.com ([209.85.210.56]:61092 "EHLO
	mail-da0-f56.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2JSWIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:08:10 -0400
X-Greylist: delayed 5156 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2012 18:08:10 EDT
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Fri, 19 Oct 2012 13:42:12 -0700 (PDT)
In-Reply-To: <fa.eH+BpYDdp4xIWE4V+wJu6hFrVxM@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=12.54.94.21; posting-account=xi0WOAoAAACnQKCn54iceAmaVmqGb9zN
NNTP-Posting-Host: 12.54.94.21
References: <fa.1zfuXwqYK6u81uBoo3IdpawcpWw@ifi.uio.no> <fa.p3cpkKIGUNv0/iot3o7KT9bb98M@ifi.uio.no>
 <fa.iPHW7usT23k+cCA19L3eXEDu91Q@ifi.uio.no> <fa.7eOK+XcsKUWU4ZXhBj2K6znxrvc@ifi.uio.no>
 <fa.VGxfKOh1Z07X1TXm5PxMIlV4xu8@ifi.uio.no> <fa.eH+BpYDdp4xIWE4V+wJu6hFrVxM@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 12.54.94.21
MIME-Version: 1.0
Message-ID: <b0b75b2b-961b-487a-ab03-2362c65d6972@googlegroups.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
From: rrl125@gmail.com
To: fa.linux.kernel@googlegroups.com
Cc: "Berck E. Nash" <flyboy@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any update? The messages just seem to have stopped months ago. A fallback would be nice, I have been booting the kernel with noa2xpic for since kernel 3.2, and currently I am working with 3.6.2.

If needed I can try to attempt modifying the patch to include fallback, but I am probably not the best person to do it.

On Sunday, December 18, 2011 3:49:27 AM UTC-5, Ingo Molnar wrote:
> * Berck E. Nash <flyboy@gmail.com> wrote:
> 
> 
> 
> > On 12/12/2011 10:13 PM, Yinghai Lu wrote:
> 
> > > please check -v7.
> 
> > 
> 
> > Works just fine for me.
> 
> 
> 
> That's interesting.
> 
> 
> 
> Now if this could be made completely automatic (no extra 
> 
> parameter passing), then we have a usable fallback mode - which 
> 
> is preferred to crashing the box.
> 
> 
> 
> Thanks,
> 
> 
> 
> 	Ingo
> 
> --
> 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> 
> the body of a message to majordomo@vger.kernel.org
> 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Please read the FAQ at  http://www.tux.org/lkml/

