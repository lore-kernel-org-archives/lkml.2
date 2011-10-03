Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab1JCU7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:59:55 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:48899 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932587Ab1JCU7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:59:48 -0400
Date: Mon, 3 Oct 2011 13:59:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 10/21] drm/i915: Wrap DP EDID fetch
 functions to enable eDP panel power
Message-ID: <20111003135937.7e3734a1@jbarnes-desktop>
In-Reply-To: <1317344993-24945-11-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
	<1317344993-24945-1-git-send-email-keithp@keithp.com>
	<1317344993-24945-11-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 18:09:42 -0700
Keith Packard <keithp@keithp.com> wrote:

> Talking to the eDP DDC channel requires that the panel be powered
> up. Wrap both the EDID and modes fetch code with calls to turn the vdd
> power on and back off.
> 

These VDD AUX changes look good, ack on all of them.

-- 
Jesse Barnes, Intel Open Source Technology Center
