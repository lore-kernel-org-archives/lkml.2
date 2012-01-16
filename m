Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab2APReF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:34:05 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:56126 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755592Ab2APReC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:34:02 -0500
Message-ID: <4F146D33.4090302@xenotime.net>
Date: Mon, 16 Jan 2012 10:32:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@amd64.org>, linux-edac@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 11 (mce_amd.c)
References: <20120111162301.108aef681cfe253f0d521ac8@canb.auug.org.au> <4F0E466D.7060005@xenotime.net>
In-Reply-To: <4F0E466D.7060005@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 06:33 PM, Randy Dunlap wrote:
> On 01/10/2012 09:23 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20120110:
> 
> 
> arch/x86/built-in.o: In function `threshold_create_bank':
> mce_amd.c:(.cpuinit.text+0x61ad): undefined reference to `cpu_llc_shared_map'
> 
> 
> i386 randconfig file is attached.


This build error is still present in linux-next 20120116.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
