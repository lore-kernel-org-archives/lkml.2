Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1DTVIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:08:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22020 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1DTVId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 17:08:33 -0400
MIME-Version: 1.0
Message-ID: <219cfb09-b910-4284-ac96-8c14c116afb4@default>
Date: Wed, 20 Apr 2011 14:06:06 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <rjw@sisk.pl>
Cc: <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>, <greg@kroah.com>,
        <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next] driver core: syscore exports for modular APM
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
From: rjw@sisk.pl
To: greg@kroah.com, randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Sent: Wednesday, April 20, 2011 1:39:18 PM GMT -08:00 US/Canada Pacific
Subject: Re: [PATCH -next] driver core: syscore exports for modular APM

On Wednesday, April 20, 2011, Rafael J. Wysocki wrote:
> On Tuesday, April 19, 2011, Greg KH wrote:
> > On Tue, Apr 19, 2011 at 08:35:46AM -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > When CONFIG_APM=m, build fails with:
> > > 
> > > ERROR: "syscore_suspend" [arch/x86/kernel/apm.ko] undefined!
> > > ERROR: "syscore_resume" [arch/x86/kernel/apm.ko] undefined!
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Rafael, care to send this to Linus?  Or do you want me to?
> 
> I will.  Or better I'll fold it into the patch, it hasn't been
> sent to Linus yet.

| The problem should be fixed in today's linux-next.  Randy, can you confirm,
| please?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes, it's fixed there.  Thanks.
