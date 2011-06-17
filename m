Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab1FQONA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:13:00 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:57364 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754185Ab1FQOM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:12:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kTiTBkKag4zcFD7P4ivZcnFnhhegX76TlgjxG1DuyZ08v9mrO3jHx+Nv9WN9NFp/foEwnEIR8+e8XOBugxViqnld0kybEe/h+zOOMTo+uqPUuJ9CKrx4OL8R+p7SqJoC;
Date: Fri, 17 Jun 2011 07:12:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Sun, Yi" <yi.sun@intel.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, Eric Anholt <eric@anholt.net>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        "Meng, Mengmeng" <mengmeng.meng@intel.com>
Subject: Re: [Intel-gfx] [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
Message-ID: <20110617071247.2f293938@jbarnes-desktop>
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B568EC644CB@shsmsx502.ccr.corp.intel.com>
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
	<6E3BC7F7C9A4BF4286DD4C043110F30B568EC644CB@shsmsx502.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 15:52:58 +0800
"Sun, Yi" <yi.sun@intel.com> wrote:

> All,
> Thank for Mengmeng¡¯s testing work, now the status is as following:
> 
> The bug33394(performance regression: screen stuttered when running the demo of 3D games with compiz enabled without GPU semaphores) is fixed. The two issue(stutter and hangcheck) is gone, now.
> The issue described as bug 36407 isn¡¯t able to be reproduced.
> The bug 36653 is still there.

Thanks for testing, looks like this is an important fix (36652 is what
I think you mean on the last one?).

-- 
Jesse Barnes, Intel Open Source Technology Center
