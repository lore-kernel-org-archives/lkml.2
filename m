Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0IUQ1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:27:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58068 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757920Ab0IUQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:27:03 -0400
X-Sasl-enc: n8EPaRwtucAh/dfZMf9L8bTFaZ4yXOl20Y5JB2ps9YAI 1285086421
Date: Tue, 21 Sep 2010 13:26:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jarek Poplawski <jarkao2@gmail.com>, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v3] ip: fix truesize mismatch in ip fragmentation
Message-ID: <20100921162657.GA22183@khazad-dum.debian.net>
References: <20100920174443.GA5515@elliptictech.com>
 <1285006844.2323.17.camel@edumazet-laptop>
 <20100920195256.GA14330@elliptictech.com>
 <1285013853.2323.148.camel@edumazet-laptop>
 <1285018272.2323.243.camel@edumazet-laptop>
 <20100921140501.GA21572@elliptictech.com>
 <1285078613.2617.503.camel@edumazet-laptop>
 <1285084705.2617.636.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285084705.2617.636.camel@edumazet-laptop>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should this be a candidate for -stable?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
