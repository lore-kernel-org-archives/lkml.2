Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1KXUPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 15:15:12 -0500
Received: from eazy.amigager.de ([213.239.192.238]:43958 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1KXUPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 15:15:11 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Nov 2011 15:15:11 EST
Date: Thu, 24 Nov 2011 21:05:53 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
 metering applications has gone crackers
Message-ID: <20111124200553.GA13353@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <1718181782.740375.1322130615898.JavaMail.mail@webmail19>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1718181782.740375.1322130615898.JavaMail.mail@webmail19>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 10:30:15 +0000, Artem S. Tashkinov wrote:
> Hello,
> 
> I'd like to report a weird regression in Linux 3.2 (running rc3 now) - all CPU metering applications have gone terribly mad
> under this kernel:

I get the same using top, htop and the gnome system monitor with kernel
3.2 on a Sandy Bridge quad core box, running Debian unstable.

Regards,
Tino
