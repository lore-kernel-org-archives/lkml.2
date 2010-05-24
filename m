Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab0EXQPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 12:15:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48470 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab0EXQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 12:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bfex646/2YEEUyKpQollNqOu8GgGO0A1UnPmh2F0qaP/dhGcNQwg81UDZhwQCAJrD2
         mAW4w2jL04DYFm7xYqgB2vgVRWj+w4+7J7tm9iEN6qJX5YGwS6n6NB98HtW5sc0hbncK
         H7OABRe9giG6wDCWUpNOeiFead2w3sSI6D5gY=
Date: Mon, 24 May 2010 09:15:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100524161527.GC3182@core.coreip.homeip.net>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524160805.GO30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 06:08:05PM +0200, Daniel Mack wrote:
> Hi Dmitry,
> 
> any feelings about this approach?
> 

Still pondering...I applied the very first patch though...

Thanks.

-- 
Dmitry
