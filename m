Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1BWUYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:24:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46826 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1BWUYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:24:06 -0500
MIME-Version: 1.0
Message-ID: <fc9a9123-cc27-4754-9222-796890553ee6@default>
Date: Wed, 23 Feb 2011 12:23:34 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Valdis.Kletnieks@vt.edu, Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: RE: linux-next still missing patch for zcache modular Kconfig/build
 issue
References: <21508.1298491740@localhost>
In-Reply-To: <21508.1298491740@localhost>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D656CDB.00B9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> Sent: Wednesday, February 23, 2011 1:09 PM
> Subject: linux-next still missing patch for zcache modular
> Kconfig/build issue
> 
> I know this is a known and solved problem with CONFIG_ZCACHE=m I hit a
> while back:
> 
>   Building modules, stage 2.
>   MODPOST 258 modules
> ERROR: "xv_malloc" [drivers/staging/zcache/zcache.ko] undefined!
> ERROR: "tmem_new_pool" [drivers/staging/zcache/zcache.ko] undefined!
> ERROR: "tmem_put" [drivers/staging/zcache/zcache.ko] undefined!
> ERROR: "tmem_destroy_pool" [drivers/staging/zcache/zcache.ko]
> undefined!
> ERROR: "xv_free" [drivers/staging/zcache/zcache.ko] undefined!
> ERROR: "xv_get_object_size" [drivers/staging/zcache/zcache.ko]
> undefined!
> ERROR: "tmem_get" [drivers/staging/zcache/zcache.ko] undefined!
> ERROR: "tmem_flush_object" [drivers/staging/zcache/zcache.ko]
> undefined!
> ERROR: "tmem_flush_page" [drivers/staging/zcache/zcache.ko] undefined!
> 
> The patch for this isn't in the linux-next tree I pulled yesterday -
> what happened to it?


GregKH hasn't yet pulled the fix into staging-next, which feeds
into linux-next.  See:

https://lkml.org/lkml/2011/2/18/311 
https://lkml.org/lkml/2011/2/18/342 
