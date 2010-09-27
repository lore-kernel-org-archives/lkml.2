Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab0I0Owx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:52:53 -0400
Received: from imr3.ericy.com ([198.24.6.13]:34015 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578Ab0I0Oww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:52:52 -0400
Date: Mon, 27 Sep 2010 07:52:17 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jan Beulich <JBeulich@novell.com>
CC: Chen Gong <gong.chen@linux.intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH 1/2] hwmon: uniform the init style of
 pkgtemp
Message-ID: <20100927145217.GA2712@ericsson.com>
References: <1285480800-14558-1-git-send-email-gong.chen@linux.intel.com>
 <1285480800-14558-2-git-send-email-gong.chen@linux.intel.com>
 <4CA05FA10200007800018F8B@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CA05FA10200007800018F8B@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 03:10:57AM -0400, Jan Beulich wrote:
> >>> On 26.09.10 at 07:59, Chen Gong <gong.chen@linux.intel.com> wrote:
> > pkgtemp is derived from coretemp, so some reasonable
> > logics should be applied onto pkgtemp, too. Such as
> > the init logic here.
> > 
> > Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> 
> Acked-by: Jan Beulich <jbeulich@novell.com>
> 
Applied to.

Thanks,
Guenter
