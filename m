Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab1IUFTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:19:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:32865 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab1IUFS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:18:57 -0400
In-Reply-To: <20110920.224910.1996429830782124690.davem@davemloft.net>
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com> <20110920.224910.1996429830782124690.davem@davemloft.net>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <15B014F7-0085-455D-A641-AA7ADFB68545@kernel.crashing.org>
Cc: robherring2@gmail.com, dave.martin@linaro.org, linux@arm.linux.org.uk,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/3] GIC OF bindings
Date: Wed, 21 Sep 2011 07:16:52 +0200
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just out of curiosity where does this "interrupt-parent" property
> come from?
>
> On platforms I am familiar with, the parent path is walked to the root
> and we stop at device nodes that have "interrupt-map" and
> "interrupt-map-mask" properties.

"interrupt-parent" is defined in the Open Firmware "interrupt mapping"
recommended practice, the same place as "interrupt-map" etc. are.

> The mechanism shown here seems overly simplistic and not able to  
> handle
> the cases handled by existing OF property schemes in use for several
> years on real systems.

"interrupt-parent" is only meant to be used for the simple cases.  It's
quite handy there.  It is also required in all "interrupt-controller"
nodes that aren't the root of the interrupt tree.


Segher

