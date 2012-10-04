Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804Ab2JDNmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:42:19 -0400
Received: from mailgw01.dd24.net ([193.46.215.41]:50256 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab2JDNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:42:17 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2012 09:42:17 EDT
Subject: RNG: is it possible to spoil /dev/random by seeding it from (evil)
 TRNGs
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Oct 2012 15:32:35 +0200
Message-ID: <1349357555.3396.15.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This is a question towards the crypto/entropy experts.

When seeding the kernels entropy cache (which is then ultimately used
for /dev/random), e.g. by (semi-)TRNGs like haveged[0],
audio-entropyd[1], Simtec’s Entropy Key[2] or friends... can one spoil
the randomness by that or is this impossible by design?

Of course it's easy to check the distribution of these randomness
sources, but as we see on the plain Mersenne Twister, a "perfect"
distribution is not necessarily usable for cryptography.


Further, one could imagine that closed products like the Entropy Key are
hacked or have backdoors, which may make them produce subtle patterns
that could later be used in cryptoanalysis.
(This is in no way a claim, that Simtec would do this,... just an
example.)


Cheers,
Chris.



[0] http://www.issihosts.com/haveged/
[1] http://www.vanheusden.com/aed/
[2] http://www.entropykey.co.uk/

