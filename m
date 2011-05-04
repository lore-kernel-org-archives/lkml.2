Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab1EDEIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 00:08:09 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:9057 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab1EDEHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 00:07:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAB/PwE1tgjyq/2dsb2JhbACEUKFNeLNDkRCBKoNXgQEEk0+CU4cq
Date: Wed, 4 May 2011 06:07:49 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, devel@driverdev.osuosl.org,
        Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH 2/3] pcmcia: Convert pcmcia_device_id
 declarations to const
Message-ID: <20110504040749.GA278@e-circ.dyndns.org>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Jiri Kosina <trivial@kernel.org>, devel@driverdev.osuosl.org,
	Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
	linux-kernel@vger.kernel.org
References: <cover.1304475547.git.joe@perches.com>
 <3a2eaa60387e1d5c370a09222930ad27acfb7514.1304475548.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3a2eaa60387e1d5c370a09222930ad27acfb7514.1304475548.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 07:29:01PM -0700, Joe Perches wrote:
> Saves about 50KB of data.
> ---
>  drivers/net/can/softing/softing_cs.c       |    2 +-

Acked-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
