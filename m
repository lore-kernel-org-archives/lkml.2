Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836Ab0J1R6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:58:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34686 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab0J1R6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:58:14 -0400
Message-ID: <4CC9B9A9.20904@linux.vnet.ibm.com>
Date: Thu, 28 Oct 2010 10:58:01 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Charles Manning <manningc2@actrix.gen.nz>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: How do I add yaffs file system to mainline?
References: <201010281308.16774.manningc2@actrix.gen.nz>
In-Reply-To: <201010281308.16774.manningc2@actrix.gen.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 05:08 PM, Charles Manning wrote:
> YAFFS has been used for many years as a third-party patch-in.
>
> I have recently been through the exercise of changing all the symbols to be
> more kernel friendly with the intention of mainlining into the linux tree.
>
> The code is in git at http://github.com/cdhmanning/linux-yaffs-integration/
>
> Thanks to CELF and Google for sponsoring the effort so far.
>
> What still needs to be done to mainline this?
> Who do I need to approach?

I'd say you need to post a series of incremental patches which 
introduces this filesystem, why the kernel should have it, why people 
would want it, etc.

For lots more details, you should take a look at the files in 
Documentation/development-process in the kernel source tree.

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
cjashfor@us.ibm.com
