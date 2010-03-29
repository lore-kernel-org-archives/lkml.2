Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab0C2MQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:16:42 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62781 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0C2MQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MoTeagcUxI6tAM4S6ZXVn6M9MyTayIkYIyCj0o269ft40nsOQarWInY+QfJsH6y9sU
         y/YA7dp4sBlOwXNXKhX5Onmq/mhntRGaaGBStsQLAsKpKhs6BHF7o2J43VkEoqZ2gM4a
         2YkPL1jkMf4ea+odpW+6iwUD2HW6724ir4Uzo=
Subject: Re: Network performance - iperf
From: Eric Dumazet <eric.dumazet@gmail.com>
To: michal.simek@petalogix.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>, netdev@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>,
       John Linn <John.Linn@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
In-Reply-To: <4BB09021.6020202@petalogix.com>
References: <4BB09021.6020202@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 14:16:34 +0200
Message-ID: <1269864994.2164.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 mars 2010 à 13:33 +0200, Michal Simek a écrit :

> Do you have any idea howto improve TCP/UDP performance in general?
> Or tests which can point me on weak places.

Could you post "netstat -s" on your receiver, after fresh boot and your
iperf session, for 32 MB and 256 MB ram case ?


