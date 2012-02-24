Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab2BXIRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 03:17:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58333 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2BXIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 03:17:45 -0500
Date: Fri, 24 Feb 2012 00:17:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Akio Idehara <zbe64533@gmail.com>
Cc: seth.forshee@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, rdunlap@xenotime.net,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2] Input: ALPS - Fix ALPS touchpad detection
Message-ID: <20120224081737.GA10763@core.coreip.homeip.net>
References: <4F3D009B.8080506@gmail.com>
 <20120216143210.GA30486@ubuntu-macmini>
 <4F465007.30304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F465007.30304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akio,

On Thu, Feb 23, 2012 at 11:41:11PM +0900, Akio Idehara wrote:
> This is definitely a bug which isn't fixed for nine years.
> Why this patch isn't applied to the input sub-system (or mainline)?
> 

Well, if we waited for 9 years, we could wait for couple more days...

Also, please make sure you do not send patches as:

	Content-Type: text/plain; charset=ISO-8859-1; format=flowed 

as this requires fixing up the patch manually before it can be applied.

Anyway, applied, thank you.

-- 
Dmitry
