Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab0EDGtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:49:18 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:57624 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0EDGtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r++LB8gMDhkML7IMx4a6oi/6bfhKcyAICJ6Kpcaj3BtCivgKWR7qV0muxFg7gyH9yv
         +uDcE8QqmPHKAoxRP62VTbnlJmZI7AUOdNOV3ylYXqnJVkte8Z4idAwsAv212j6lOiKp
         Bvv/4HOI83WwaWeuu94O9fpBtlx5TVMyLtjmg=
Date: Mon, 3 May 2010 23:49:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] input: mt: Simplify event bypass logic
Message-ID: <20100504064905.GB17482@core.coreip.homeip.net>
References: <1272721779-2124-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272721779-2124-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 01, 2010 at 03:49:39PM +0200, Henrik Rydberg wrote:
> The input bypass mechanism is only used by the MT events. Since all
> MT events use bypassing by construction, the current list is a mere
> duplication of input.h. This patch replaces the bypass list by a
> simple range test.
> 

Henrik,

I disagree with the patch. I can not guarantee that we will be able to
maintain continuous range of ABS_MT_* events and thus current scheme is
more flexible.

Thanks.

-- 
Dmitry
