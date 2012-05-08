Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab2EHQ1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:27:11 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58579 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754969Ab2EHQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:27:09 -0400
Message-ID: <4FA9496D.604@xenotime.net>
Date: Tue, 08 May 2012 09:27:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for May 8 (gpu/drm/gma500)
References: <20120508181531.072fdc5fefa60d852e784587@canb.auug.org.au>
In-Reply-To: <20120508181531.072fdc5fefa60d852e784587@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 01:15 AM, Stephen Rothwell wrote:

> Hi all,
> 
> There will be no linux-next tomorrow.
> 
> Changes since 20120507:



When CONFIG_ACPI is not enabled:

drivers/gpu/drm/gma500/opregion.c:269:3: error: implicit declaration of function 'register_acpi_notifier'
drivers/gpu/drm/gma500/opregion.c:288:3: error: implicit declaration of function 'unregister_acpi_notifier'

-- 
~Randy
