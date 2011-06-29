Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1F2DrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 23:47:25 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:35367 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab1F2DrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 23:47:20 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] staging: use videobuf2 framework for drivers/staging/dt3155v4l driver
Date: Wed, 29 Jun 2011 06:46:02 +0300
User-Agent: KMail/1.13.6 (Linux/2.6.39; KDE/4.5.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105282145.27809.mitov@issp.bas.bg> <20110628202515.GA9177@kroah.com>
In-Reply-To: <20110628202515.GA9177@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106290646.02960.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 28, 2011 11:25:15 pm Greg KH wrote:
> On Sat, May 28, 2011 at 09:45:27PM +0300, Marin Mitov wrote:
> > This patch transforms drivers/staging/dt3155v4l driver to use videobuf2 framework.
> > Tested and works with "xawtv -f".
> > 
> > Either streaming API or read method should be selected during kernel configuration.
> 
> I've applied this, but why would you ever not want to use the streaming
> api?

There are no reasons for that, sure, but for now xawtv do not work if both are
specified in the driver. I have to debug it.

Regards.

Marin Mitov

> 
> thanks,
> 
> greg k-h
> 
