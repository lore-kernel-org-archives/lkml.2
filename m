Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1ELPPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:15:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46828 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1ELPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:15:18 -0400
Date: Thu, 12 May 2011 08:13:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>
Subject: Re: [PATCH-v3 14/14] iscsi-target: Add Makefile/Kconfig and update
 TCM top level
Message-Id: <20110512081357.106419c0.randy.dunlap@oracle.com>
In-Reply-To: <1305184041-32189-15-git-send-email-nab@linux-iscsi.org>
References: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
	<1305184041-32189-15-git-send-email-nab@linux-iscsi.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DCBF944.0003:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 00:07:21 -0700 Nicholas A. Bellinger wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Add Makefile/Kconfig and update drivers/target/[Makefile,Kconfig]
> to include the fabric module.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/Kconfig        |    1 +
>  drivers/target/Makefile       |    1 +
>  drivers/target/iscsi/Kconfig  |   18 ++++++++++++++++++
>  drivers/target/iscsi/Makefile |   20 ++++++++++++++++++++
>  4 files changed, 40 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/target/iscsi/Kconfig
>  create mode 100644 drivers/target/iscsi/Makefile
> 
> diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
> new file mode 100644
> index 0000000..abdb8f9
> --- /dev/null
> +++ b/drivers/target/iscsi/Kconfig
> @@ -0,0 +1,18 @@
> +config ISCSI_TARGET
> +	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> +	depends on m
> +	select CRYPTO
> +	select CRYPTO_CRC32C
> +	select CRYPTO_CRC32C_INTEL if X86
> +	help
> +	Say M here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
> +	Target Mode Stack.

Just curious:  why is this available only as a loadable module?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
