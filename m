Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0ERJGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 05:06:50 -0400
Received: from bamako.nerim.net ([62.4.17.28]:62122 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab0ERJGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 05:06:49 -0400
Date: Tue, 18 May 2010 11:06:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for intel PCI thermal 
 subsystem
Message-ID: <20100518110645.242c7f6d@hyperion.delvare>
In-Reply-To: <20100411132437.554cee22@hyperion.delvare>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com>
	<20100411132437.554cee22@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

On Sun, 11 Apr 2010 13:24:37 +0200, Jean Delvare wrote:
> On Fri, 11 Dec 2009 10:52:30 -0500, Matthew Garrett wrote:
> > (...)
> > +MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
> > +MODULE_DESCRIPTION("Intel thermal subsystem hwmon driver");
> > +MODULE_LICENSE("GPL");
> 
> Update wanted, if you want this upstream, obviously...

Any news on this? I need an update soon if you want this driver in
kernel 2.6.35.

-- 
Jean Delvare
