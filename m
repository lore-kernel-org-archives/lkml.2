Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2EFLLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 07:11:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21361 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2EFLLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 07:11:16 -0400
Date: Sun, 6 May 2012 14:12:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, andor.daam@googlemail.com,
        grabner@icg.tugraz.at, jj@chaosbits.net, stefanha@gmail.com,
        thomas@m3y3r.de
Subject: Re: [PATCH 1/8] drivers/staging/line6/control.c: Change
 strict_strtoul to kstrtoul
Message-ID: <20120506111251.GM22134@mwanda>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
 <1336228312-5379-2-git-send-email-morbidrsa@googlemail.com>
 <20120506063450.GH22134@mwanda>
 <1336292842.7144.2.camel@blackbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336292842.7144.2.camel@blackbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 10:27:22AM +0200, Johannes Thumshirn wrote:
> On Sun, 2012-05-06 at 09:34 +0300, Dan Carpenter wrote:
> > On Sat, May 05, 2012 at 04:31:45PM +0200, Johannes Thumshirn wrote:
> > > Changed strict_strtoul() call to kstrtoul to make checkpatch.pl happy
> > > 
> > 
> > This would probably be better as kstrtou8(). You'd have to change
> > the type of value, and the function parameters which take value as
> > well.  Also you would have to change the name of pod_set_param_int()
> > because it says "int".
> > 
> > 
> > regards,
> > dan carpenter
> > 
> 
> Ok I'll look over these patches again, but I've got another question
> regarding these, should I re-diff against the current linux-next or
> against these patches?
> 

Current linux-next, please.  Unless you recieved an email that Greg
merged them, then they will be included in linux-next and both
answers are equivalent.

regards,
dan carpenter

