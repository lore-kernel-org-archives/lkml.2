Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0EJSXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:23:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60556 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab0EJSXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:23:10 -0400
Message-ID: <4BE84ED7.5010207@zytor.com>
Date: Mon, 10 May 2010 11:22:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>	<1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>	<1273258266.1540.63.camel@Joe-Laptop.home>	<20100507200208.09b2941d@lxorguk.ukuu.org.uk>	<1273259187.1540.75.camel@Joe-Laptop.home>	<4BE47059.8090101@zytor.com> <20100510171707.28da6795@feng-i7>
In-Reply-To: <20100510171707.28da6795@feng-i7>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 02:17 AM, Feng Tang wrote:
> 
> Thank you all for the comments. please review this follow-on patch.
> 
> - Feng

That doesn't move it to common code, though.  I'd rather see existing
common style used, then merged (centralized) and *then* the style corrected.

	-hpa
