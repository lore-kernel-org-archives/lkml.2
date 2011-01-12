Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab1ALRe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:34:56 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49794 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1ALRey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:34:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kdASN5H+2Wa+Hqj7Bihv/RiCtwJcYP6qiADyfIHa5jq3/1dt/DzuW6zHaVkpKguLrd
         drE70mzyb0VPU55r5N4hgF6dt4n/L2y26CLErnjwE0cdwsjeIHfx0ph4jrM1H9N91nO0
         SXjrVIX9Iz8fBY655emigYtDcTCkRB0reFDQs=
Date: Wed, 12 Jan 2011 20:34:48 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, pgf@laptop.org
Subject: Re: [PATCH] olpc_battery: Ambient temperature is not available on
 XO-1.5
Message-ID: <20110112173448.GA1115@oksana.dev.rtsoft.ru>
References: <20101229191201.ED8019D401D@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101229191201.ED8019D401D@zog.reactivated.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 07:12:01PM +0000, Daniel Drake wrote:
> The XO-1.5 does not support the ambient temperature property.
> Create a separate list of properties for that configuration where
> ambient temperature is not included, and apply the correct property
> list at runtime.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
