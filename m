Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1FMJAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:00:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40544 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab1FMJAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WNOSPHN8tp9Pz5hVgO3W9WJ9xylH2u/T4QH3vBf4rKrBSEa67voLH3qrvWRcAg1SXF
         uHuY2WeOdplwSi83EBowSnuGzBZUXi593CPBhqPjmQ9gF3QpDS/+C9jq6GFHWX5vn+/y
         IqQe0dd9MejL5T18fVKAhsOJblxPe65+PqKSU=
Date: Sat, 11 Jun 2011 16:21:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Anirudh Ghayal <aghayal@codeaurora.org>
Subject: Re: [PATCH 1/2] input: pmic8xxx-keypad: Do not use mfd_get_data()
Message-ID: <20110611232146.GB3979@core.coreip.homeip.net>
References: <20110608091341.GJ2880@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608091341.GJ2880@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 11:13:41AM +0200, Samuel Ortiz wrote:
> 
> mfd_get_data() has been removed from the MFD API.
> 
> Cc: Anirudh Ghayal <aghayal@codeaurora.org>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

Samuel, do you want to push this and the other patch with my acks
through your tree?

Thanks!

-- 
Dmitry
