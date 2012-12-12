Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab2LLBQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 20:16:32 -0500
Received: from popelka.ms.mff.cuni.cz ([195.113.20.131]:35266 "EHLO
	popelka.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2LLBQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 20:16:30 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 20:16:30 EST
Date: Wed, 12 Dec 2012 03:03:54 +0100
From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
To: linux-kernel@vger.kernel.org
Subject: [RFC] AES instead of SHA1 for /dev/urandom
Message-ID: <20121212020354.GA30879@domone.kolej.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I consider to speed-up /dev/urandom on recent intel processors by
using hardware aes. Same for accelerated aes crypto.

Would you accept a patch if I wrote it?

