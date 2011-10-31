Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1JaVL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:11:28 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:39706
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab1JaVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:11:27 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Subject: [RFC PATCH 00/10] powerpc/mpic: General cleanup patch series
Date: Mon, 31 Oct 2011 17:10:01 -0400
Message-Id: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been tinkering with a series of patches to clean up the PowerPC
MPIC/OpenPIC init recently as part of a new board port I'm working on.

It's reached the point where I'd like some feedback on the general
approach.  The code itself hasn't been tested at all yet, and probably
does not compile right now (though that is my next step).

(Oh, actually, the first patch isn't really even about the MPIC code,
it should probably be reviewed on its own; oh well...)

Please let me know what you think.

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/

