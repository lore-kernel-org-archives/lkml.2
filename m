Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab2EURn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:43:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43382 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759322Ab2EURnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:43:06 -0400
Message-ID: <4FBA7E95.5040101@zytor.com>
Date: Mon, 21 May 2012 10:42:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: mingo@kernel.org, levinsasha928@gmail.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, printk: Add missing KERN_CONT to NMI selftest
References: <1336492573-17530-3-git-send-email-levinsasha928@gmail.com>  <tip-29d679ffd850ea37a303bb930142be14982611e4@git.kernel.org> <1337621394.13812.2.camel@joe2Laptop>
In-Reply-To: <1337621394.13812.2.camel@joe2Laptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 10:29 AM, Joe Perches wrote:
> 
> I believe this change is no longer required.
> Kay's printk modifications have been updated.
> 
> It's somewhat useful, but the commit message
> but not the commit subject is untrue.
> 

Still, the KERN_CONT should be there.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

