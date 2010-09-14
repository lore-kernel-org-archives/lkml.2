Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0INRk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:40:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53286 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab0INRk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:40:56 -0400
Date: Tue, 14 Sep 2010 19:40:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100914194050.3f688136@basil.nowhere.org>
In-Reply-To: <20100914151723.GL26290@redhat.com>
References: <45864.91.60.148.9.1284474680.squirrel@www.firstfloor.org>
	<20100914151723.GL26290@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> From what someone explained to me, the only platform that implements
> AER correctly is Nehalem based ones.  So for AMD and Intel Core
> arches, AER is not expected to work.  Is that incorrect?

At least for Intel it's definitely not true. AER goes back a
lot of generations, pretty much all that support PCI Express. 

There were some bugs in it of course and some workarounds needed, but
no show stoppers in any particular part to my knowledge.

Haven't kept fully track of AMD systems recently, but would surprise
me if it was the case on AMD either.

This applies to servers. On clients AER is more spotty
and various simply don't have it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
