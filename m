Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab2I1NYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:24:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43614 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab2I1NYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:24:08 -0400
Date: Fri, 28 Sep 2012 16:23:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?Fran=E7ois?= Boisson 
	<user.anti-spam@maison.homelinux.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: shutdown with toshiba portege
Message-ID: <20120928132354.GG28937@mwanda>
References: <20120920204234.0fb035a89f88a2e1f468aa54@maison.homelinux.net>
 <20120921165753.7a5701fc6a0e1445daa92500@maison.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120921165753.7a5701fc6a0e1445daa92500@maison.homelinux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 04:57:53PM +0200, François Boisson wrote:
> Le Thu, 20 Sep 2012 20:42:34 +0200
> François Boisson  <user.anti-spam@maison.homelinux.net> a écrit:
> 
> > Hey 
> > 
> > I have a problem which seems to be related to shutdown for a Toshiba portege
> > (it's seems that the problem is also on other Toshiba, on VAIO cw5, y
> [...]
> > If i shutdown the computer and wait some hours, the power consumption of the
> > computer is not null, it's about the same as the power consumtion during a
> > suspend of computer. In fact
> > 
> > Boot and halt with:
> > Windows 7 ---> No power consumption after
> > Linux 2.6.37-486-PAE --->  No power consumption after
> > Linux >= 3.0  ---> Power consumption (about 45-50 mW if acpitool is correct)
> [...]
> 
> Well can anybody just tell me the sequence of shutdown and power of a x86
> computer in then linux kernell, or just how to verify that a device is power
> off with a printk, or where to search or even only where is the part of code
> doing this. There is many documentation about use device but nothing about
> power off.
> 

So your Toshiba is going into suspend instead of power off...

There are several ways that computers shutdown but modern systems
use ACPI.  It could be that the 2.6.37-486-PAE was using a
different method.  I've CC'd the ACPI list.

regards,
dan carpenter
