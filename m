Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1EAFbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 01:31:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50541 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1EAFbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 01:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iIksO05w0omw8wEYE6s/WDDYvRpcq9K9iyRvp1QlyrdhW0HeX+JJjiRfd8tfMPsjG5
         gsE7gM4YMY6k681UXERsPKoBLHSV+SYA0ZAVqP5QEXEbtMK/PkQtLS0sygSFUpsM5gRv
         +a4L507TDRtPjyIiaHfD0rmy2F4kCXLE7lybA=
Date: Sat, 30 Apr 2011 22:31:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mohan Pallaka <mpallaka@codeaurora.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.intradead.org,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 2/2] input: misc: Add support for isa1200 chip
Message-ID: <20110501053135.GA10886@core.coreip.homeip.net>
References: <1302697533-20456-1-git-send-email-mpallaka@codeaurora.org>
 <1302697533-20456-3-git-send-email-mpallaka@codeaurora.org>
 <4DA69A17.8080207@codeaurora.org>
 <4DBAB3A2.9040100@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBAB3A2.9040100@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mohan,

On Fri, Apr 29, 2011 at 06:18:34PM +0530, Mohan Pallaka wrote:
> Ping.
> 

Sorry for the delay. The patch looks good, but could you tell me if you
got the ack for the "weak" annotation for PWM symbols?

Thanks.

-- 
Dmitry
