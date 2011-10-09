Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1JIXFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 19:05:50 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:46775 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751014Ab1JIXFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 19:05:48 -0400
Message-ID: <4E9228CA.1060904@xenotime.net>
Date: Sun, 09 Oct 2011 16:05:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: balbi@ti.com
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH -next] usb gadget: fix langwell_udc.c build error
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au> <4E8F67C6.5020603@xenotime.net> <20111008100326.GA24633@legolas.emea.dhcp.ti.com> <4E91DF00.8060107@xenotime.net> <20111009223638.GA29776@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111009223638.GA29776@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/11 15:36, Felipe Balbi wrote:
> git log --pretty=oneline -S'lpm_device_speed' HEAD --	\
> 	drivers/usb/gadget/langwell_udc.c

e538dfdae85244fd2c4231725d82cc1f1bc4942c usb: Provide usb_speed_string() function


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
