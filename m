Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2BMRqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:46:38 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:43120 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755653Ab2BMRqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:46:36 -0500
Message-ID: <4F394C59.2000604@xenotime.net>
Date: Mon, 13 Feb 2012 09:46:01 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: linux-next: Tree for Feb 13 (staging/zsmalloc)
References: <20120213172613.be7258c4c34431ff31dcbbef@canb.auug.org.au>
In-Reply-To: <20120213172613.be7258c4c34431ff31dcbbef@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 10:26 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20120210:


zsmalloc-main.c should #include <linux/mmzone.h> to fix this build error:


drivers/staging/zsmalloc/zsmalloc-main.c: In function 'obj_location_to_handle':
drivers/staging/zsmalloc/zsmalloc-main.c:254:32: error: 'MAX_PHYSMEM_BITS' undeclared (first use in this function)
drivers/staging/zsmalloc/zsmalloc-main.c: In function 'obj_handle_to_location':
drivers/staging/zsmalloc/zsmalloc-main.c:266:10: error: 'MAX_PHYSMEM_BITS' undeclared (first use in this function)

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
