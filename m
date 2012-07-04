Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab2GDHqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:46:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12877 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986Ab2GDHqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:46:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jul 2012 00:46:36 -0700
Message-ID: <4FF3F54F.1060809@nvidia.com>
Date: Wed, 4 Jul 2012 16:48:31 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: Use of the pwm-names DT property
References: <4FF3E862.8050101@nvidia.com> <20120704073942.GC25386@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120704073942.GC25386@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04 Jul 2012 04:39:42 PM JST, Thierry Reding wrote:
> In fact the *-names properties are rather common. They are used for the
> reg and interrupts properties. The pinctrl subsystem and the upcoming
> clock bindings also use the *-names properties. So one could just as
> well argue that the regulator and gpio bindings should have been using
> regulator-names and gpio-names respectively instead.

I was not aware of that, thanks for the explanation. Too bad the DT is 
already split in two different ways for naming things.

Alex.
