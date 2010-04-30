Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab0D3RN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:13:57 -0400
Received: from www.tglx.de ([62.245.132.106]:36196 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796Ab0D3RMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:12:43 -0400
Date: Fri, 30 Apr 2010 12:02:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: Phil Carmody <ext-phil.2.carmody@nokia.com>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
In-Reply-To: <y2xe6bf505b1004290852xa079969k3316c5bb7233de13@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004301201450.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>  <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>  <1272399798.2255.2.camel@localhost>  <1272400246.2255.5.camel@localhost>  <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>
  <20100429151555.GM17639@pcarmody-desktop> <y2xe6bf505b1004290852xa079969k3316c5bb7233de13@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010, Xianghua Xiao wrote:
> I confirm that 2.6.33.3-rt15 worked fine, reboot/umount will not oops.

Just pushed out 2.6.33.3-rt17 which has the problem fixed. Can you
please verify that it works for you as well ?

Thanks,

	tglx
