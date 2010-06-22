Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab0FVPbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:31:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64280 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0FVPbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:31:23 -0400
Date: Tue, 22 Jun 2010 08:30:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 22 (staging/spectra)
Message-Id: <20100622083032.8abe1605.randy.dunlap@oracle.com>
In-Reply-To: <20100622160518.2ef7afcc.sfr@canb.auug.org.au>
References: <20100622160518.2ef7afcc.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C20D740.00BC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 16:05:18 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100621:
> 
> My fixes tree contains:
>       v4l-dvb: update gfp/slab.h includes
>       arm: update gfp/slab.h includes
>       davinci: update gfp/slab.h includes
>       ocfs2: update gfp/slab.h includes
>       acpi: update gfp/slab.h includes


drivers/staging/spectra/ffsport.c:307: error: implicit declaration of function 'blk_fs_request'

Where is this function??

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
