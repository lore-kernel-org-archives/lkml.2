Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1A1Lmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 06:42:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48438 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab1A1Lmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 06:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=TLpJQu97rLMxuH/QsXKz/V96KdgXq34wMBZoW0d2mcKrIQL1H3/5imadKPWYmvmRow
         mtomwyDSdwaHR2a7FHTb9UVpF7H7vaLhPVJiq9GI3ksjm5Si0rUPvTj6xufWyv/+e6mV
         1SXeRSAmiy4vCKOFfhMwmLsBRXhyTXxwHsrWc=
Date: Fri, 28 Jan 2011 14:42:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Vipin Mehta <vmehta@atheros.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] staging: ath6kl: Convert A_UINT8 is_amsdu and
 is_acl_data_frame to A_BOOL
Message-ID: <20110128114214.GD20606@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joe Perches <joe@perches.com>, Vipin Mehta <vmehta@atheros.com>,
	devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <cover.1296186677.git.joe@perches.com>
 <3a5cf32b0de8cd3153d385e2198d7aa4c787697e.1296186677.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a5cf32b0de8cd3153d385e2198d7aa4c787697e.1296186677.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 08:04:29PM -0800, Joe Perches wrote:
> -                A_UINT8 is_amsdu, tid, is_acl_data_frame;
> +                A_BOOL is_amsdu;
> +                A_UINT8 tid;
> +                A_BOOL is_acl_data_frame;

Just use bool for bool and u8 for u8.  It's not reasonable for everyone
to rename basic types for every driver.  (Unless Atheros bool really is
different from other people's bool then it would be totally reasonable).

regards,
dan carpenter
