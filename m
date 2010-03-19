Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab0CSLip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:38:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0CSLio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:38:44 -0400
Message-ID: <4BA36239.4070909@infradead.org>
Date: Fri, 19 Mar 2010 08:38:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Jeremy Kerr <jk@ozlabs.org>
CC: users@linux.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] [KORG] Availability of SSL on kernel.org
References: <4BA2CFB7.7070108@kernel.org> <20100319035806.GB25308@linux-sh.org> <201003191600.13474.jk@ozlabs.org>
In-Reply-To: <201003191600.13474.jk@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

Jeremy Kerr wrote:
> Hi Paul,
> 
> Thanks for the report and testing - I've just committed a fix, plus a change 
> to reflect the https URL in the sample .pwclientrc file.
> 
> J.H.: If you update to the current git HEAD, the pwclient and .pwclientrc 
> files served by patchwork.kernel.org will now be more suitable for use with 
> https.

It worked after commenting this line:

#        xmlrpclib.SafeTransport.__init__(self)

Without commenting, I get this bug:

Traceback (most recent call last):
  File "/usr/local/bin/pwclient", line 463, in ?
    main()
  File "/usr/local/bin/pwclient", line 381, in main
    use_https)
  File "/usr/local/bin/pwclient", line 88, in __init__
    xmlrpclib.SafeTransport.__init__(self)
AttributeError: class SafeTransport has no attribute '__init__'


Btw, I had to do the same with the older pwclient. I'm using here the python/python libraries
provided on RHEL5.


Cheers,
Mauro

-- 

Cheers,
Mauro
