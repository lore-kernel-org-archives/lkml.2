Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab2ERQW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:22:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:37052 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab2ERQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:22:26 -0400
Date: Fri, 18 May 2012 12:22:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: <linux-next@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>,
        <linux-kernel@vger.kernel.org>
Subject: [linux-next] "edac: Remove the legacy EDAC ABI"
Message-ID: <20120518162216.GB15256@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

This commit:

-----------
commit 90b40d5cadba20d7fe2fce12d61f97e0870c1ba6
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed May 2 14:37:00 2012 -0300

    edac: Remove the legacy EDAC ABI

    Now that all drivers got converted to use the new ABI, we can
    drop the old one.
----------

breaks linux-next i386 allmodconfig:

drivers/edac/amd76x_edac.c:254:25: error: too few arguments to function
'edac_mc_alloc'
make[3]: *** [drivers/edac/amd76x_edac.o] Error 1
drivers/edac/i82875p_edac.c:424:3: error: label 'fail0' used but not
defined
drivers/edac/i82875p_edac.c:427:2: error: expected identifier or '('
before 'do'

http://kisskb.ellerman.id.au/kisskb/buildresult/6341714/

Please have a look.

Thanks,
Paul.


