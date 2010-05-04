Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0EDHeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:34:11 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:11131 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab0EDHeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:34:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAF9p30tbst7L/2dsb2JhbACdL3K7FA6FBASDXg
Date: Tue, 4 May 2010 09:34:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] watchdog: update/improve/consolidate watchdog
	driver parameters
Message-ID: <20100504073402.GZ15728@infomag.iguana.be>
References: <20100503114252.f915b476.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503114252.f915b476.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randi,

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Move the limited watchdog driver help from kernel-parameters.txt
> to Documentation/watchdog/watchdog-parameters.txt and add info to it
> for all watchdog drivers except the ones that have driver-specific
> files already.
> 
> Correct minor comments and MODULE_PARM_DESC() text in 2 places.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

I will add this to the linux-2.6-watchdog-next tree.

Kind regards,
Wim.

