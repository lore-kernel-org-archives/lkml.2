Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab2HITNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:13:09 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:53498 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755071Ab2HITNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:13:07 -0400
Message-ID: <50240B70.3000800@xenotime.net>
Date: Thu, 09 Aug 2012 12:11:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for Aug 9 (staging/csr)
References: <20120809131317.3d289a0b98a13c72001154fb@canb.auug.org.au>
In-Reply-To: <20120809131317.3d289a0b98a13c72001154fb@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 08:13 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120807:
> 



(on i386)

ERROR: "register_inetaddr_notifier" [drivers/staging/csr/csr_wifi.ko] undefined!
ERROR: "unregister_inetaddr_notifier" [drivers/staging/csr/csr_wifi.ko] undefined!

when CONFIG_INET is not enabled.

CSR_WIFI probably should depend on INET.


-- 
~Randy
