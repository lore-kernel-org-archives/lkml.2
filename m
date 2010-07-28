Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0G1OmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:42:06 -0400
Received: from peer.zerties.org ([188.40.33.175]:41580 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab0G1OmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:42:01 -0400
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: CONFIG_IPIPE
Date: Wed, 28 Jul 2010 16:14:54 +0200
Message-ID: <86bp9rhew1.fsf@peer.zerties.org>
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

        I've been running a check on the arch/blackfin sourcetree for
config Items not defined in Kconfig and found such a case. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel.

I've seen, that there is no configuration Option for CONFIG_IPIPE in the
vanilla kernel. There are 36 cases of dead blocks within arch/blackfin
referencing CONFIG_IPIPE. So i thought, i ask, if this is a out of tree
development, which should be merged in the future, before i start
writing patches.

Regards

        Christian Dietrich

[0] http://vamos1.informatik.uni-erlangen.de
-- 
(λ x . x x) (λ x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
