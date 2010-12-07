Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0LGOzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:55:23 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:35951 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0LGOzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:55:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Mdwj8VerDjyijqVY1O5uxJAgo0h3d5RmUo739j0WLFSPDO8I+82l0Hq1kHyxfLmzND
         5JBeocmNyt8C7M/qnzuyd7rTIaaW+a+26L6tKJiIYfqhZYtOYxKFW2Hpa2pDT3a0NiN7
         ONNPoPJC1P0I/bF/Szf2RBKd3PLBbw8ujO5d8=
Date: Tue, 7 Dec 2010 12:55:16 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf: Allow strong and weak functions in LIB_OBJS
Message-ID: <20101207145516.GA7612@ghostprotocols.net>
References: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com>
 <1290658375-10342-2-git-send-email-imunsie@au1.ibm.com>
 <20101126211836.GA5864@ghostprotocols.net>
 <1290991642-sup-5890@au1.ibm.com>
 <1291704103-sup-9818@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291704103-sup-9818@au1.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 07, 2010 at 05:42:58PM +1100, Ian Munsie escreveu:
> Excerpts from Ian Munsie's message of Mon Nov 29 11:53:07 +1100 2010:
> > I'm not seeing any of those warnings or errors on either of the systems
> > I have been testing on (x86_64 + PPC64), but it looks like the linker is
> > trying to pull in too much from the system libraries.
> > 
> > Can you test the below patch to see if the messages go away - it only
> > applies the whole-archive flag to libperf.a, whereas before I was also
> > applying it to pthread, libelf, etc.
> 
> Hey Arnaldo,
> 
> Just wondering if you got around to testing this patch?

Yeah, fell thru the cracks, but I tested it now on several systems and
it now seems ok, applying to perf/core, thanks,

- Arnaldo
