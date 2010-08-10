Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab0HJM3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:29:01 -0400
Received: from peer.zerties.org ([188.40.33.175]:58172 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab0HJM25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:28:57 -0400
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "vamos-dev\@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Subject: Dead Config Option STMMAC_ETH?
Date: Tue, 10 Aug 2010 14:28:47 +0200
Message-ID: <86r5i6vegw.fsf@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
       
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

        I've been running a check on the drivers/net/stmmac sourcetree for
config Items not defined in Kconfig and found such a case. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

As far as i can see in drivers/net/stmmac/Kconfig STMMAC_ETH and several
depending flags are dead in the linux vanilla kernel, because it depends
on CPU_SUBTYPE_ST40, but there isn't a Kconfig option for that. But
f96691872439ab2071171d4531c4a95b5d493ae5 suggests, that support for this
ST40 plattform was removed in 2007.

There seems to be, that there was much effort on the stmmac drivers in
the last few months, so i just wanted to ask if this problem is known.

Regards

        Christian Dietrich

[0] http://vamos1.informatik.uni-erlangen.de
-- 
(λ x . x x) (λ x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
