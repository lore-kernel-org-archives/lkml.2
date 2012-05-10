Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2EJRnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:43:41 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:45086 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760343Ab2EJRnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:43:40 -0400
Message-ID: <1336671665.16730.228.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 3/7] ACPI: Add _OST support for sysfs eject
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 11:41:05 -0600
In-Reply-To: <1336668931.2581.27.camel@lorien2>
References: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
	 <1336507944-10219-4-git-send-email-toshi.kani@hp.com>
	 <1336581973.2498.15.camel@lorien2>
	 <1336587377.16730.150.camel@misato.fc.hp.com>
	 <1336664428.2581.21.camel@lorien2>
	 <1336667664.16730.201.camel@misato.fc.hp.com>
	 <1336668931.2581.27.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 10:55 -0600, Shuah Khan wrote:
> On Thu, 2012-05-10 at 10:34 -0600, Toshi Kani wrote:
> 
> > _OST is the ACPI standard method for the platform to receive the status
> > of hotplug operations.  Some platforms may require the OS to support
> > _OST in order to support ACPI hotplug operations.  For instance, if the
> > platform has the management console where user can request a hotplug
> > operation from, this _OST support would be required for the management
> > console to show the result of a hotplug request to user.  
> > 
> 
> This will be a good information capture in the change log.

Sounds good.  I will add this information to patch 0/1 and 1/1.


> Thanks Toshi. It is interesting to have platforms require optional
> methods. Guess  you can never rule out weirdness in how these Specs.
> actually get implemented :)

It is optional for platforms to implement it.  But when some platforms
start implementing it, it is necessary for the OS to support it. :) 


Thanks,
-Toshi




