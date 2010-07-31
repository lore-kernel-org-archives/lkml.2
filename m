Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0GaGdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 02:33:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36027 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab0GaGdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 02:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VyXcsnmm+bal+YnMb8QPRj1/u4bJdRRofhcK2m3pRCl4VnzTj9GVF1jGmWgSzel8ij
         +OIq0/1GPf3XiIbFBBAgcHCcseEL9bC1VN53LgpVFxSoV2O8DVBkLzZiasZzCja6klJ1
         cUa7USB7ONJZxwMGGVbhrqtqqbDePOueDCrvg=
Date: Fri, 30 Jul 2010 23:33:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, vapier@gentoo.org, pavel@ucw.cz,
        akpm@linux-foundation.org, khilman@deeprootsystems.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.y.miao@gmail.com
Subject: Re: [PATCH] Input: Make ADS7846 independent on regulator
Message-ID: <20100731063329.GA23620@core.coreip.homeip.net>
References: <1280555108-27994-1-git-send-email-marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280555108-27994-1-git-send-email-marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Sat, Jul 31, 2010 at 07:45:08AM +0200, Marek Vasut wrote:
> In case regulator was not found, ADS7846 failed to probe.
> 
> This fixes a problem on some Sharp Zaurus devices, where there is no regulator
> present and yet the touchscreen is used.
> 

Too many ifdefs to my taste... Can we have ads7846_regulator_enable()
and friends stubbed out in case !CONFIG_REGULATOR?

-- 
Dmitry
