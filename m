Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1BYNCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 08:02:51 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:60063 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1BYNCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 08:02:50 -0500
Date: Fri, 25 Feb 2011 14:02:41 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Pratheesh Gangadhar <pratheesh@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com, hjk@hansjkoch.de,
        gregkh@suse.de, tglx@linutronix.de, arnd@arndb.de,
        amit.chatterjee@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources
 used by PRUSS UIO driver
Message-ID: <20110225130241.GA2791@local>
References: <1298556402-26456-1-git-send-email-pratheesh@ti.com>
 <1298556402-26456-2-git-send-email-pratheesh@ti.com>
 <1298556402-26456-3-git-send-email-pratheesh@ti.com>
 <4D6796D6.5050008@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6796D6.5050008@mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 02:47:34PM +0300, Sergei Shtylyov wrote:
> On 24-02-2011 17:06, Pratheesh Gangadhar wrote:
> 
> >This patch defines PRUSS, ECAP clocks, memory and IRQ resources
> >used by PRUSS UIO driver in DA850/AM18xx/OMAPL1-38 devices. UIO
> 
>    It's OMAP-L138.

>From the TI wiki: "The PRU subsystem is supported on
OMAP-L1x8/C674m/AM18xx devices (where m is an even number)."

http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem

Thanks,
Hans

