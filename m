Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0LMCek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 21:34:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57420 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab0LMCej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 21:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qmSy+f3irB1chl0VwYfWsWumvPRuKytTt+F5RY6AUbr89hL2DfrxH5Zg/1zP9Jv3DD
         F8/J5BTEi0BOwQvVNRsBNJbiLyBENP0f3AY8M0mUsH8ua+PODsBFfZVVFVhZVw+x3X59
         qSb+pJado1tk3JTZ04dc7623rX6TVuKWfeZGk=
Date: Sun, 12 Dec 2010 18:34:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] input: mt: Support separate contact and finger count
 reports
Message-ID: <20101213023430.GB21401@core.coreip.homeip.net>
References: <1292063308-15327-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292063308-15327-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 11:28:27AM +0100, Henrik Rydberg wrote:
> A number of old and semi-recent touch devices are capable of counting
> the number of fingers on the pad within being able to give details for
> all individual contacts. This patch simplifies reporting for such
> hardware by providing a separate function for finger count.
> 

Looks good, just a couple nits below.

>  
>  /**
> + * input_mt_report_finger_count() - report contact count via buttons

"via buttons" is awkward, I'd simply dropped it,

> + * @dev: input device with allocated MT slots
> + * @count: the number of contacts
> + *
> + * Reports the contact count via BTN_TOOL_FINGER, BTN_TOOL_DOUBLETAP,
> + * BTN_TOOL_TRIPLETAP and BTN_TOOL_QUADTAP.
> + *
> + * The input core ensures only the KEY axes already setup for

s/axes/events/ ?

-- 
Dmitry
