Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2GJNbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:31:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45886 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2GJNbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:31:16 -0400
Date: Tue, 10 Jul 2012 16:31:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Marcos Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH 0/3] staging: bcm: Cleanup bcm driver
Message-ID: <20120710133102.GB6056@mwanda>
References: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
 <20120710024046.GA8894@gmail.com>
 <CAH0vN5Kv6MzVGLxBEAeuUGPRoDC9+8aHkPrZZduFqddEMZrsSg@mail.gmail.com>
 <20120710123840.GA2928@gmail.com>
 <20120710125156.GE6113@mwanda>
 <CAKPrQY8ZMSOMDDANKAfXOe6tp+Tnk8Eba=OVpd_z_AFOtJDbtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKPrQY8ZMSOMDDANKAfXOe6tp+Tnk8Eba=OVpd_z_AFOtJDbtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 09:24:23AM -0400, Kevin McKinney wrote:
> On Tue, Jul 10, 2012 at 8:51 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Tue, Jul 10, 2012 at 08:38:41AM -0400, Kevin McKinney wrote:
> >> On Mon, Jul 09, 2012 at 11:48:09PM -0300, Marcos Souza wrote:
> >> > 2012/7/9 Kevin McKinney <klmckinney1@gmail.com>:
> >> > > On Mon, Jul 09, 2012 at 10:32:37PM -0300, Marcos Paulo de Souza wrote:
> >> > >> Hi Kernel guys!
> >> > >>
> >> > >> This new patchset tries to clean a little the bcm driver, removing
> >> > >> some unused macros and some dead code.
> >> > >>
> >> > >> These macros and dead code were reported by the forgotten-macros tool
> >> > >> (https://github.com/marcosps/forgotten_macros).
> >> > >>
> >> > >> The tool is under development, but all the patches looks like OK.
> >> > >>
> >> > >> This patchset is based in staging-next.
> >> > >>
> >> > >> Thanks guys!
> >> > >
> >> > > The patchset looks good!
> >> >
> >> > Thanks for the answer Kevin!!
> >> >
> >> > So, do I have your ack?
> >> Yes, I ack.
> >
> > The normal format is:
> >
> > Acked-by: Your Name <email@address.com>
> >
> > Some maintainers have scripts which pick Acked-by tags automatically
> > or even if they don't they can copy and paste it.
> 
> Okay, thanks for this info Dan. I will see if I can write this script.
> 

No, what I'm saying is that I know Dave Miller uses a script which
pulls the Acked-by's out of email threads and adds them
automatically.  I don't know how Greg does it, but it's better to
use the normal format.

regards,
dan carpenter
