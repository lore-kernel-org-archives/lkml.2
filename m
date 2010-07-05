Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0GETr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:47:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44302 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab0GETrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:47:25 -0400
Message-ID: <4C32364D.2040705@zytor.com>
Date: Mon, 05 Jul 2010 12:45:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: feng.tang@intel.com
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       jacob.jun.pan@intel.com, dtor@mail.ru, randy.dunlap@oracle.com
Subject: Re: [PATCH v2 0/5] patches to settle i8042 with Intel MID platforms
References: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
In-Reply-To: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 08:03 AM, feng.tang@intel.com wrote:
> From: Feng Tang <feng.tang@intel.com>
> 
> Hi All,
> 
> Some x86 platforms like intel MID platforms don't have i8042 controllers,
> and i8042 driver's probe to some non-exist legacy IO ports may hang
> the MID processor. 
> 
> Current solution for this is add dependency of SERIO_I8042 over
> !X86_MRST, then if we build a x86 kernel image with X86_MRST=y,
> it won't have i8042 driver support over common x86 platforms.
> 
> So we add a i8042 pre-detect hook into x86_platforms ops, so that
> i8042 driver can use it to run-time judge whether to go on with
> probe process.
> 
> Please review these patches.
> 

Looks good to me.  Dmitry, what do you think?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

