Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab1C3Oqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:46:52 -0400
Received: from xes-mad.com ([216.165.139.218]:9045 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544Ab1C3Oqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:46:51 -0400
Subject: Re: [PATCH] pch_gpio: Fix output value of
 pch_gpio_direction_output()
From: Peter Tyser <ptyser@xes-inc.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
In-Reply-To: <1301487386-29101-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1301487386-29101-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 09:46:43 -0500
Message-ID: <1301496403.24947.8543.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 21:16 +0900, Tomoya MORINAGA wrote:
> The pch_gpio_direction_output() function was missing a write to set the
> desired output value.  The function would properly set the GPIO
> direction, but not the output value.  The value would have to manually
> be set with a follow up call to pch_gpio_set().
> 
> Add the missing write so that pch_gpio_direction_output() sets both the
> GPIO direction and value.
> 
> Reported-by: Peter Tyser <ptyser@xes-inc.com>
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Hi Tomoya,
I posted this same patch last week:
https://patchwork.kernel.org/patch/662621/

It looks like this driver and the ml_ioh_gpio driver are nearly
identical, hence the identical fixes.  If you have some spare cycles
it'd be nice to combine them.

Best,
Peter

