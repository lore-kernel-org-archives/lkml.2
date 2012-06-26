Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab2FZOsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:48:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35481 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757591Ab2FZOsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:48:39 -0400
Message-ID: <4FE9CBA4.3020601@zytor.com>
Date: Tue, 26 Jun 2012 07:48:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, cpufeature:   Catch duplicate CPU feature
 strings
References: <4FE34BCB.5050305@linux.intel.com> <tip-55f6cb9d0b364e7e8cb65b51193f5e4743c44fde@git.kernel.org> <20120626143246.0c9bf301@endymion.delvare>
In-Reply-To: <20120626143246.0c9bf301@endymion.delvare>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 05:32 AM, Jean Delvare wrote:
>
> You added an extra %s in the string, can't think of a good reason for
> it. perl -w would have told you, I think we should add it.
>

Ah yes, a leftover from testing.

> Other than this, the code looks good and the improvement reasonable, so
> you can add:
>
> Acked-by: Jean Delvare <khali@linux-fr.org>
>

Should probably be reviewed-by: but nevertheless...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



