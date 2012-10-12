Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053Ab2JLSa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:30:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41843 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2JLSaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:30:25 -0400
Subject: Re: [PATCH v2] net: calxedaxgmac: rework transmit ring handling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jonathan@jonmasters.org, Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Ben Hutchings <bhutchings@solarflare.com>
In-Reply-To: <1350065099-32649-1-git-send-email-robherring2@gmail.com>
References: <1350054908-30646-6-git-send-email-robherring2@gmail.com>
	 <1350065099-32649-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Oct 2012 20:30:20 +0200
Message-ID: <1350066620.21172.12996.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 13:04 -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Only generate tx interrupts on every ring size / 4 descriptors. Move the
> netif_stop_queue call to the end of the xmit function rather than
> checking at the beginning.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
> v2:
> - Add missed enabling of the descriptor tx interrupt

Seems to be net-next material to me.

Furthermore, your changelog is a bit terse for such a patch, that could
easily break upper layers.

You need to tell us how long TX completion for a packet might be
deferred.

Thanks


