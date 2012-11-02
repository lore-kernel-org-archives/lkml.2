Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab2KBOPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:15:21 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:29632 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2KBOPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:15:19 -0400
Message-ID: <1351865256.19172.105.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 0/2] ACPI: CPU hot-remove support
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, imammedo@redhat.com,
        vijaymohan.pandarathil@hp.com, prarit@redhat.com, bhelgaas@google.com
Date: Fri, 02 Nov 2012 08:07:36 -0600
In-Reply-To: <1678274.pulvZO82Js@vostro.rjw.lan>
References: <1351780933-30560-1-git-send-email-toshi.kani@hp.com>
	 <1678274.pulvZO82Js@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 13:46 +0100, Rafael J. Wysocki wrote:
> On Thursday, November 01, 2012 08:42:11 AM Toshi Kani wrote:
> > This patchset adds support of CPU hot-remove via an ACPI eject
> > notification to the ACPI processor driver.  The CPU hot-remove
> > operation shares the same code path with the sysfs eject operation.
> > 
> > The patchset also exports two functions necessary to initiate
> > hot-remove operations from modules, such as the processor driver.
> > 
> > The patchset is based on the current Linus's tree.
> > 
> > v3:
> > - Added patch 1/2 to export functions for hot-remove
> > 
> > v2:
> > - Rebased to the latest baseline
> > 
> > ---
> > Toshi Kani (2):
> >  ACPI: Export functions for hot-remove
> >  ACPI: Add ACPI CPU hot-remove support
> 
> Both patches applied to the linux-next branch of the linux-pm.git
> tree as v3.8 material.

Great!!  Thanks Rafael!
-Toshi


> 
> Thanks,
> Rafael
> 
> 
> > ---
> >  drivers/acpi/osl.c              |  1 +
> >  drivers/acpi/processor_driver.c | 27 +++++++++++++++++----------
> >  drivers/acpi/scan.c             |  1 +
> >  3 files changed, 19 insertions(+), 10 deletions(-)
> > 


