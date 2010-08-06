Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab0HFA6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:58:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60027 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0HFA6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VwWAbiiy6dBN0UrylLeznUMLnyDc8/88Vk+7QdwOeRyKztf9pW+pFwp6idg1O9MxWG
         Oqxry2jNrh9pbC8RaIpY/2010ocquwh7R7R2BlVnj/HJJZrsjas19lHVseX287ToAb0G
         fDYvVWrL6bV2ub89r3ADbOT/Ya4rs5F3MNBcs=
Date: Fri, 6 Aug 2010 02:58:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend
	on LOCKUP_DETECTOR
Message-ID: <20100806005801.GB5436@nowhere>
References: <4C58C7FF.5060906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C58C7FF.5060906@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 09:53:03AM +0800, Li Zefan wrote:
> CONFIG_DETECT_SOFTLOCKUP has been removed, so switch the
> default value to LOCKUP_DETECTOR.
> 
> Also fix the help text of BOOT_PRINTK_DELAY.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.

