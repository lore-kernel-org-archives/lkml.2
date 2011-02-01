Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1BARtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:49:39 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:38456 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab1BARth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:49:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pviBZ5t4oOOsZQk1s/H+t/UrqM4wYrIAcGbsq2E5tHpitiSeZViY+UE7aRoW/sK0NK
         2AHN3iMNN/g7RZBTd1+Hzg8zvjjxWsBNeIPbRNyWL0xplN4p2+un1RvAKqlp0VE+n/4t
         16TePNxCpcS8ySN4mDnNUooX0Ro8p/ykaVjok=
Date: Tue, 1 Feb 2011 09:49:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anirudh Ghayal <aghayal@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [RFC v2 PATCH 4/7] input: pmic8058_pwrkey: Add support for power
 key
Message-ID: <20110201174911.GA518@core.coreip.homeip.net>
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org>
 <1296568063-12010-5-git-send-email-aghayal@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296568063-12010-5-git-send-email-aghayal@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 07:17:40PM +0530, Anirudh Ghayal wrote:
> From: Trilok Soni <tsoni@codeaurora.org>
> 
> Add support for PMIC8058 power key driven over dedicated
> KYPD_PWR_N pin. It allows the user to specify the amount
> of time by which the power key reporting can be delayed.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
> ---
> Changes from v1:
> Addressed review comments from Dmitry.
> Added KEY_SCREENLOCK instead of KEY_END.

...
> +	input_report_key(pwrkey->pwr, KEY_SCROLLLOCK, 1);
...
> +	input_report_key(pwrkey->pwr, KEY_SCREENLOCK, 0);
...
> +	input_set_capability(pwr, EV_KEY, KEY_SCROLLLOCK);


You are confused about the event you are sending.

Thanks.

-- 
Dmitry
