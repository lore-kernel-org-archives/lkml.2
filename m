Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935430Ab0GPC6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:58:37 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57402 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935288Ab0GPC6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:58:36 -0400
X-Sasl-enc: qlNNr7uPaDOHAOyREUBb4TGAURENce43mK9flS+0jqDO 1279249115
Date: Thu, 15 Jul 2010 23:58:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ed W <lists@wildgooses.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
Message-ID: <20100716025832.GG27512@khazad-dum.debian.net>
References: <4C3D94E3.9080103@wildgooses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3D94E3.9080103@wildgooses.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Ed W wrote:
> Hi, my network connection looks like 500Kbits with a round trip
> latency of perhaps 1s+ (it's a satellite link).

Last time I dealt with such stuff (hundreds of VSATs across the whole
country, arriving at a Satellite Base Station), you absolutely had to use
protocol enhancement proxies in the SBS AND in the VSAT clients to get good
performance for typical end-user Internet usage.  This was a few years ago,
but it probably hasn't changed much.  I don't recall what proprietary stuff
was used for the proxy, but...

http://en.wikipedia.org/wiki/Performance_Enhancing_Proxy
http://sourceforge.net/projects/pepsal/

A Google search for pepsal will return a link to a PDF explaining the
design.  Maybe that could be of some help for you?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
