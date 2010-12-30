Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0L3WBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 17:01:09 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:45640 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751342Ab0L3WBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 17:01:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Oig9Ru11YpPYudPGf6SAqFxErKEcIwzleQ541akRK9Zwcx4tNQ+3qx13iJ81o0C2HgKdWlKrGPa1N9kGDc32cbDwhEc8pQghLkLNBAKBYEQte+0LSIYtT1rpOH1+oKG3;
Date: Thu, 30 Dec 2010 14:01:03 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] i915 fixes
Message-ID: <20101230140103.1189c545@jbarnes-desktop>
In-Reply-To: <0d30dc$kjvpke@orsmga001.jf.intel.com>
References: <0d30dc$kjvpke@orsmga001.jf.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010 19:01:34 +0000
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Hi Linus,
> 
> Dave asked to me send this pull request directly to you as he is on
> holiday over the New Year. In this batch, there are a few regression
> fixes. The most notable being the revert of the SSC frequency switch,
> along with a use-before-initialisation introduced much earlier in the
> sdvo/hdmi audio enabling and a fix for the loss of correct modesetting on
> one particular DVO chipset. Eric also found another instance where we were
> not adhering to the specs when setting up Ironlake. The impact is not
> conclusively known but we did find a few scenarios where it delayed a
> hang.
> -Chris
> 
> The following changes since commit 387c31c7e5c9805b0aef8833d1731a5fe7bdea14:
> 
>   Linux 2.6.37-rc8 (2010-12-28 17:05:48 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git drm-intel-fixes
> 
> Chris Wilson (4):
>       drm/i915/sdvo: Add hdmi connector properties after initing the connector
>       drm/i915: Verify Ironlake eDP presence on DP_A using the capability fuse
>       Revert "drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks"
>       drm/i915/dvo: Report LVDS attached to ch701x as connected

Did you want to disable SSC entirely on gen5+ just so we can get all
the known machines working?  It's possible it could add some wifi or
sound interference, but that's better than not having a display (most
of the time).

-- 
Jesse Barnes, Intel Open Source Technology Center
