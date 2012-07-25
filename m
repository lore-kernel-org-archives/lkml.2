Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2GYXjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:39:49 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:9915 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2GYXjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:39:47 -0400
Message-ID: <1343259296.3010.424.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 0/4] ACPI: hotplug messages improvement
From: Toshi Kani <toshi.kani@hp.com>
To: Joe Perches <joe@perches.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Wed, 25 Jul 2012 17:34:56 -0600
In-Reply-To: <1343259112.11398.4.camel@joe2Laptop>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com>
	 <1343259112.11398.4.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 16:31 -0700, Joe Perches wrote:
> On Wed, 2012-07-25 at 17:12 -0600, Toshi Kani wrote:
> > This patchset improves logging messages for ACPI CPU, Memory, and
> > Container hotplug notify handlers.  The patchset introduces a set of
> > new macro interfaces, acpi_pr_<level>(), and updates the notify
> > handlers to use them.  acpi_pr_<level>() appends "ACPI" prefix and
> > ACPI object path to the messages, and its usage model is similar to
> > dev_<level>().  This improves diagnostics in hotplug operations
> > since it identifies an object that caused an issue in a log file.
> > 
> > v3:
> >  - Changed acpi_pr_debug() to NOP when !DEBUG and !DYNAMIC_DEBUG.
> >    DYNAMIC_DEBUG will be supported later.
> >  - Added const to a path variable in acpi_printk().
> >  - Added more descriptions to the change log of patch 1/4.
> 
> Thanks Toshi.
> 
> This seems sensible to me.  I've no more comments either.

Thanks Joe for the valuable suggestions!
-Toshi



