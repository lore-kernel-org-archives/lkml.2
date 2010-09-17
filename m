Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab0IQUeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:34:05 -0400
Received: from www.tglx.de ([62.245.132.106]:42833 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab0IQUeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:34:03 -0400
Date: Fri, 17 Sep 2010 22:33:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] uio: Don't clear driver data
In-Reply-To: <m1occ0894p.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1009172232530.2416@localhost6.localdomain6>
References: <m1y6b48973.fsf@fess.ebiederm.org> <m1occ0894p.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Sep 2010, Eric W. Biederman wrote:

> 
> Currently uio sets it's driver data to NULL just as it is unregistering
> attributes.  sysfs maks the guaranatee that it will not call attributes
  
  s/maks/makes/

> after device_destroy is called so this is unncessary and leads to lots
> of unnecessary code in uio.c
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

