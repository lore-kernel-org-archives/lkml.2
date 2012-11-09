Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2KIPWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:22:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63023 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KIPWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:22:12 -0500
Date: Fri, 9 Nov 2012 07:22:03 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [ANNOUNCE] Extended stable support for Linux 3.5
 (linux-3.5.y-ext.z)
Message-ID: <20121109152203.GA3861@elie.Belkin>
References: <1352470505-6097-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352470505-6097-1-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herton,

Herton Ronaldo Krzesinski wrote:

> I plan to do a similar workflow as to what is done today with current
> stable releases. I'll send email notifications to everyone involved in
> each patch when it's added to 3.5 queue, and post the patches for review
> for each release cycle. Just versioning will be slightly different,
> every version is planned to be tagged as v3.5.7-ext.<release number>,
> ext meaning extended, 3.5.7 was the last stable kernel in 3.5 kernel and
> should remain constant.

Thanks for your work.  Is there a reason not to work with Greg to
release these on kernel.org with increasing 3.5.8, 3.5.9, etc version
numbers?

Curious,
Jonathan
