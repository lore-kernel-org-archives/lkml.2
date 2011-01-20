Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1ATXeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:34:24 -0500
Received: from xenotime.net ([72.52.115.56]:39545 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755863Ab1ATXeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:34:23 -0500
Date: Thu, 20 Jan 2011 15:34:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: purpleidea@gmail.com, scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, DL-MPTFusionLinux@lsi.com
Subject: Re: Status of the LSI 2108
Message-Id: <20110120153419.806d38e1.rdunlap@xenotime.net>
In-Reply-To: <1295411153.20086.81.camel@localhost>
References: <1295411153.20086.81.camel@localhost>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jan 2011 23:25:53 -0500 James Shubin wrote:

> Hi,
> 
> I've been trying to find out if the LSI 2108 is fully supported in the
> vanilla kernel, and any thoughts as to the quality/robustness.
> 
> This seems to be the correct source:
> ftp://ftp.supermicro.nl/driver/SAS/LSI/2108/Driver/Linux/v04.31/
> however I'm not sure at all if it's maintained, or what. I would
> outright test this myself, however I haven't bought the servers yet
> 
> Thanks for your help,
> Please cc-me on replies.

Hi,

Probably better to ask on the linux-scsi mailing list [added].
Also added the lsi.com email address.


drivers/scsi/mpt2sas/mpt2sas_scsih.c contains this:

	/* Liberator ~ 2108 */
	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_1,
		PCI_ANY_ID, PCI_ANY_ID },
	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_2,
		PCI_ANY_ID, PCI_ANY_ID },
	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_3,
		PCI_ANY_ID, PCI_ANY_ID },

so it looks like there is at least some basic support for the 2108.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
