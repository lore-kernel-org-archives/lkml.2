Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab0FYP2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:28:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56195 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab0FYP2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:28:21 -0400
Date: Fri, 25 Jun 2010 17:28:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug disable boot option
Message-ID: <20100625152819.GC13421@basil.fritz.box>
References: <4C24012B.9030506@austin.ibm.com>
 <20100625105340.803C.A69D9226@jp.fujitsu.com>
 <87d3vfeage.fsf@basil.nowhere.org>
 <4C24C279.3050206@austin.ibm.com>
 <20100625145622.GB13421@basil.fritz.box>
 <4C24C96F.4030709@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C24C96F.4030709@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, this would work to reduce the number of memory sections created.  The reason

Note it could be done on the sysfs interface level too, e.g. have one
entry that gets a bitmap as input/output.

> I have not gone this route is that increasing the memory section size would
> break DLPAR memory add and remove for powerpc pseries.

How would it break it?

But aren't you breaking this anyways by disabling the sysfs entries?!?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
