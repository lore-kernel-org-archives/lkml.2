Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0ERVwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:52:10 -0400
Received: from mail.perches.com ([173.55.12.10]:2349 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab0ERVwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:52:09 -0400
Subject: Re: [PATCH] staging/comedi/comedi.h: cleanups
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Mark Rankilor <reodge@gmail.com>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Bernd Porr <berndporr@f2s.com>, Gorskin Ilya <revent82@gmail.com>
In-Reply-To: <20100518214213.GA6764@kroah.com>
References: <1273746519-4590-1-git-send-email-reodge@gmail.com>
	 <1273746519-4590-2-git-send-email-reodge@gmail.com>
	 <1273747232.21514.22.camel@Joe-Laptop.home>
	 <20100514205023.GA23779@kroah.com> <20100514205114.GA27844@kroah.com>
	 <1274040918.1705.432.camel@Joe-Laptop.home>
	 <20100518214213.GA6764@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 14:52:06 -0700
Message-ID: <1274219526.17703.119.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 14:42 -0700, Greg KH wrote:
> On Sun, May 16, 2010 at 01:15:18PM -0700, Joe Perches wrote:
> > Just general neatening, reduces checkpatch plaints
> > from 15 to 3.
> >  drivers/staging/comedi/comedi.h | 1410 ++++++++++++++++++++-------------------
> What tree did you make this against?

linux-next, after you pulled a9560a72759c6208c4072a30fb45aac7c6c014d4

