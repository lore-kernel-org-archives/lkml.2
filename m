Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab0CSTxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 15:53:19 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:38578 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751197Ab0CSTxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 15:53:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tRERGKLZHCKZvmyBiAl1wv2x2sai2ImYSPwMRz1E6eSIL4q0sft1/tXwXn5yOygTFO4xyXPrffYQIcV+Tmr6DXeoEVP6kq9btlAOkMz8blWdydlr6GhO6OzOYWPUfF8G;
Date: Fri, 19 Mar 2010 12:53:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Surbhi Palande <surbhi.palande@canonical.com>
Cc: dri-devel@lists.sourceforge.net, Chris Wilson <chris@chris-wilson.co.uk>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, yakui.zhao@intel.com, zhenyuw@linux.intel.com,
       Len Brown <lenb@kernel.org>
Subject: Re: ACPI _LID failures
Message-ID: <20100319125320.22d8b25d@jbarnes-piketon>
In-Reply-To: <cover.1268680514.git.surbhi.palande@canonical.com>
References: <89k83ahv05c@azsmga001.ch.intel.com>
	<cover.1268680514.git.surbhi.palande@canonical.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 21:32:41 +0200
Surbhi Palande <surbhi.palande@canonical.com> wrote:

> The following two patches are quirks that blacklist bios which report
> incorrect lid status. These are bioses for machines with a 900 GM.
> The first one is tested by Ubuntu users and the second one isn't.
> Further testing will be appreciated.
> 
> 
> Surbhi Palande (2):
>   drm/i915: blacklist lid status: Sony VGN-BX196VP
>   drm/i915: blacklist lid status: Elite Co. G335
> 
>  drivers/gpu/drm/i915/intel_lvds.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)

Patches look ok to me.  Len was curious about whether some recent ACPI
EC fixes will fix some of our lid detection bugs though.

Len, is there any particular patch or version people should try?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
