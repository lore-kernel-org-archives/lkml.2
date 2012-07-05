Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2GEXqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:46:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41386 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476Ab2GEXqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:46:17 -0400
X-Sasl-enc: V+UvRnn8IrQWrciTSHFas16xvUMYwLuy5ABNTRxCkH85 1341531976
Date: Thu, 5 Jul 2012 20:46:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: twofish-avx - remove useless instruction
Message-ID: <20120705234612.GD29301@khazad-dum.debian.net>
References: <20120705184358.GE2091@kronos.redsun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705184358.GE2091@kronos.redsun>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jul 2012, Johannes Goetzfried wrote:
> The register %rdx is written, but never read till the end of the encryption
> routine. Therefore let's delete the useless instruction.

Is it useless, or is it there to harden against some side-channel
attack?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
