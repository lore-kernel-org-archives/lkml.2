Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0D1TjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:39:07 -0400
Received: from www.tglx.de ([62.245.132.106]:57726 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab0D1TjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:39:04 -0400
Date: Wed, 28 Apr 2010 21:38:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
In-Reply-To: <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004282137330.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>  <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>  <1272399798.2255.2.camel@localhost>  <1272400246.2255.5.camel@localhost>  <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>
  <1272434481.1974.101.camel@work-vm>  <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>  <alpine.LFD.2.00.1004281833230.2951@localhost.localdomain> <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Xianghua Xiao wrote:
> Thomas,
> I patched it and re-run it however did not find any condition from
> your patch had a hit.
> In your patch I changed :
> 
> if (!file->f_path) {
> to
> if(!(&(file->f_path))){
> Otherwise it won't compile as f_path is a not a pointer.

True :)
 
> # reboot
> # Oops: Kernel access of bad area, sig: 11 [#1]

Ok. Can you please enable CONFIG_DEBUG_LIST ?

Thanks,

	tglx
