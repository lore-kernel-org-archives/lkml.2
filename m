Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2FXVCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 17:02:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46016 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2FXVCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 17:02:31 -0400
Message-ID: <4FE77FB9.8010209@zytor.com>
Date: Sun, 24 Jun 2012 13:59:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, cpufeature:   Rename X86_FEATURE_DTS to
 X86_FEATURE_DTHERM
References: <4FE34BCB.5050305@linux.intel.com> <tip-3bac8715443fc83413e221a5cd9d5cf3d82b79b4@git.kernel.org> <20120624214908.4177fc4a@endymion.delvare> <4FE77B11.1000808@zytor.com>
In-Reply-To: <4FE77B11.1000808@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2012 01:39 PM, H. Peter Anvin wrote:
>
> It isn't about finger-pointing, it is about a failure of process; we had
> a process that would have caught this problem and the process failed.
> There are certainly blame enough to go around, but I think one of the
> things here is that lack of response isn't necessary an ACK - it may
> actually be that the patch looked at first glance like it had no impact
> on our area (incorrectly as it turned out.)
>

Let me be clear: I'm not blaming you, or anyone else, personally.  Like 
many other failures, there were a number of steps in the chain here, one 
of them being not checking this in the script from the beginning, and 
that one is mine.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



