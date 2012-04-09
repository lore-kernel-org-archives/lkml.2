Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2DIPMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:12:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46166 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2DIPMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:12:47 -0400
Message-ID: <4F82FC6C.1090501@wwwdotorg.org>
Date: Mon, 09 Apr 2012 09:12:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] alsa: hide HDMI/ELD printks unless in debug kernels
References: <20120409021517.GA14618@localhost>
In-Reply-To: <20120409021517.GA14618@localhost>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2012 08:15 PM, Fengguang Wu wrote:
> These trivial messages will show up repeatedly on hot plug as well as
> video mode changes, which could be annoying.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Those messages are very useful for end-users to diagnose problems with
HDMI audio. Is there a way to make the messages dynamic, so users can
get them if they want, without recompiling their kernel?
