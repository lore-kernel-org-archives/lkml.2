Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1KII7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:59:05 -0500
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1029 "HELO
	smtp-out-103.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750936Ab1KII7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:59:04 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14722
Message-ID: <4EBA40E3.60203@metafoo.de>
Date: Wed, 09 Nov 2011 09:59:15 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111005 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: What happened to vcoalesce?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

I'm using the kernel firmware loader on a blackfin board. And this currently
doesn't work with mainline since the firmware loader uses vmap. In the ADI
blackfin Linux tree there is a patch written by you, which fixes this.

What is the status of that patch in regard to going mainline? I found a
mailing-list post from January where you tried to submit it upstream, but
there was a minor bug in the patch and so the it was rejected. In March you
posted the fixed up version and from than on I couldn't find references to
it anymore.

Thanks,
- Lars
