Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab0ICJWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:22:54 -0400
Received: from mx1.moondrake.net ([212.85.150.166]:59529 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751966Ab0ICJWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:22:52 -0400
X-Greylist: delayed 1790 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2010 05:22:52 EDT
X-Spam-Virus: No
From: Arnaud Patard <apatard@mandriva.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Bernhard Walle <walle@corscience.de>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, ddaney@caviumnetworks.com,
        akpm@linux-foundation.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: N32: Fix getdents64 syscall for n32
References: <1283501734-6532-1-git-send-email-walle@corscience.de>
	<20100903084213.GA32339@lst.de>
Organization: Mandriva
Date: Fri, 03 Sep 2010 10:53:31 +0200
In-Reply-To: <20100903084213.GA32339@lst.de> (Christoph Hellwig's message of "Fri, 3 Sep 2010 10:42:13 +0200")
Message-ID: <m3pqwvb438.fsf@anduin.mandriva.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

Hi,

> I'm not sure why people suddenly started Ccing me on utterly random
> patches, but could you guys please bloody stop it?  Thanks!

I guess the explanation is the one below :

$ ./scripts/get_maintainer.pl -f arch/mips/kernel/scall64-n32.S
Ralf Baechle <ralf@linux-mips.org>
David Daney <ddaney@caviumnetworks.com>
Andrew Morton <akpm@linux-foundation.org>
"Eric W. Biederman" <ebiederm@xmission.com>
Christoph Hellwig <hch@lst.de>
linux-mips@linux-mips.org
linux-kernel@vger.kernel.org


Arnaud
