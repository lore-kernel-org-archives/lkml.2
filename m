Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1F2STA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:19:00 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:41379 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1F2SS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:18:59 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] staging: use videobuf2 framework for drivers/staging/dt3155v4l driver
Date: Wed, 29 Jun 2011 21:17:39 +0300
User-Agent: KMail/1.13.6 (Linux/2.6.39; KDE/4.5.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105282145.27809.mitov@issp.bas.bg> <201106290646.02960.mitov@issp.bas.bg> <20110629042124.GA18344@kroah.com>
In-Reply-To: <20110629042124.GA18344@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106292117.40272.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 29, 2011 07:21:24 am Greg KH wrote:
> On Wed, Jun 29, 2011 at 06:46:02AM +0300, Marin Mitov wrote:
> > On Tuesday, June 28, 2011 11:25:15 pm Greg KH wrote:
> > > On Sat, May 28, 2011 at 09:45:27PM +0300, Marin Mitov wrote:
> > > > This patch transforms drivers/staging/dt3155v4l driver to use videobuf2 framework.
> > > > Tested and works with "xawtv -f".
> > > > 
> > > > Either streaming API or read method should be selected during kernel configuration.
> > > 
> > > I've applied this, but why would you ever not want to use the streaming
> > > api?
> > 
> > There are no reasons for that, sure, but for now xawtv do not work if both are
> > specified in the driver. I have to debug it.
> 
> Ok, but why not just remove the read method then?  Or do some userspace
> programs still require it?

In current version if you select streaming API you effectively remove read method.
If you select read method you effectively remove streaming API. At lest this is
what userland programs are seeing as driver capabilities.

For now I see some changes in videobuf2-core are in discussion. When they become part
of the kernel I will test the driver again.

Thanks.

Marin Mitov

> 
> greg k-h
> 
