Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2DWQiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:38:20 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:52457 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752292Ab2DWQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:38:18 -0400
Message-ID: <4F958598.6080305@xenotime.net>
Date: Mon, 23 Apr 2012 09:38:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ebiederm@xmission.com, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 23 (phonet sysctl)
References: <20120423170701.c96e402234b1387dece11dda@canb.auug.org.au>
In-Reply-To: <20120423170701.c96e402234b1387dece11dda@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 12:07 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120420:



ERROR: "unregister_net_sysctl_table" [net/phonet/phonet.ko] undefined!
ERROR: "register_net_sysctl" [net/phonet/phonet.ko] undefined!

when CONFIG_SYSCTL is not enabled.

-- 
~Randy
