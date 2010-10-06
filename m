Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab0JFRyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 13:54:13 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11799 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab0JFRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 13:54:11 -0400
Message-ID: <4CACB7C3.9030000@caviumnetworks.com>
Date: Wed, 06 Oct 2010 10:54:11 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/28] Staging: comedi: drivers.c: Edit file so that checkpatch.pl
 has 4 warnings and 0 errors
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com> <1286326843-6170-7-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1286326843-6170-7-git-send-email-tdent48227@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2010 17:54:18.0774 (UTC) FILETIME=[7FB0DB60:01CB657F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 06:00 PM, Tracey Dent wrote:
> Changed a few lines that made checkpatch.pl complain. Could not get ever warning but
> I got it down to to just 4, WARNING: line over 80 characters.

The overall goal is to improve the code, not placate checkpatch.pl

[...]
>   				printk
> -				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
> -				     dev->use_count);
> +				    (KERN_WARNING "BUG! detaching device     \
> +							with use_count=%d\n",
> +							dev->use_count);

Is that really an improvement?

And even if it were, is that really how strings should be split up?

Hint:
	pr_warning("BUG! detaching device with use_count=%d\n",
		   dev->use_count);


David Daney
