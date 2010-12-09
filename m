Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0LIXta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:49:30 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:34565 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0LIXt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:49:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qL5uENxQ3/T4ms1E57VH1Vs30ZadzlMFYkTrXCVXdTggbLA0NOJ7M+NLYQ6Eje6uvP
         hxwO8mLg792o4gIaSS0sJNihj1om637o1cLn6N9bR0/pMQppgThx/5WIR8zsCxSBYIVn
         OMParNNI1zJS+KurYAc5HufDNcULAsjzdz5Xw=
Date: Thu, 9 Dec 2010 15:49:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Identify pointer emulation contact
Message-ID: <20101209234920.GA14810@core.coreip.homeip.net>
References: <1291936745-4973-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291936745-4973-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 12:19:05AM +0100, Henrik Rydberg wrote:
> For MT applications, the tracking id provides a robust way to know
> when a touch is new; essential information to determine when _not_ to
> emit motion events, for instance.  Currently, ST applications do not
> have the equivalent information, but instead rely on global properties
> such as a change in number of fingers. Moreover, some MT applications
> need to know which contact correponds to the pointer. This patch adds
> the ABS_TRACKING_ID axis and emits it in
> input_mt_report_pointer_emulation(), provided the proper absbit is
> setup by the driver.
> 

So how do you propose userspace will use it? Obviously it will not help
old dumb (ST) applications and new smart applications should understand
MT protocol and thus do not need to pay much attention to ST events
anyway. Apparently you have some new dumb userspace in mind here?

Thanks.

-- 
Dmitry
