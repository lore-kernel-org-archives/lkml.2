Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0HZS1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:27:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39244 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0HZS1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=epXTwE9pRVboFOIoLD4HlAdABDQEV+7r146htZh8C3TtyhZNyHZJC+z3dOuS0rVH+0
         gucp/j8sRpiKOm/s+4Sej1vil7rEetsqbNvpqyqY/DuU7sOJUZYpJ+WEEY4tyvVzxqnU
         Db3eL9q90mrewP1py7wiYdlZBBMuCLMRnNgbc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PROBLEM] i915/drm: Insufficient FIFO for plane
Date: Thu, 26 Aug 2010 20:27:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2; KDE/4.4.5; i686; ; )
Cc: David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1008221821370.4027@tiger>
In-Reply-To: <alpine.DEB.2.00.1008221821370.4027@tiger>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008262027.24729.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 22 sierpnia 2010 o 17:26:19 Pekka Enberg wrote:
> Hi,
> 
> I'm seeing tons of these error messages with current Linus' git:
> 
> [   95.941618] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
> plane, expect flickering: entries required = 36, available = 31.
> 
> Contrary to the error message, I don't see any flickering. I've attached
> my dmesg and config.
> 
>  			Pekka
See:
https://bugzilla.kernel.org/show_bug.cgi?id=17021

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
