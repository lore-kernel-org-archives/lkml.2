Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321Ab2B1LeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:34:25 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:56346 "EHLO
	smtp.towertech.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab2B1LeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:34:24 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Feb 2012 06:34:24 EST
Date: Tue, 28 Feb 2012 12:26:52 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rtc: INFO: possible circular locking dependency detected
Message-ID: <20120228122652.66cd9802@linux.lan.towertech.it>
In-Reply-To: <1330381713.5633.12.camel@lappy>
References: <1330381713.5633.12.camel@lappy>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 00:28:33 +0200
Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi all,
> 
> I've stumbled on the following lockdep warning when running trinity under the KVM tool.
> 
> (Is it the case of missing rtc->ops_lock in rtc_device_unregister?)

 Hi,

 the last time I checked we had a lock in rtc_device_unregister . I'll
 give it a look.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

