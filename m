Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2CDXed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 18:34:33 -0500
Received: from ozlabs.org ([203.10.76.45]:43219 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008Ab2CDXec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 18:34:32 -0500
Date: Mon, 5 Mar 2012 09:53:37 +1100
From: Paul Mackerras <paulus@samba.org>
To: netdev@vger.kernel.org
Cc: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Fix licensing problems in if_ppp.h
Message-ID: <20120304225336.GA10646@bloggs.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of 3 patches is primarily aimed at removing the problem
that the license on include/linux/if_ppp.h is the old BSD-style license
with advertising clause.  However, in fact virtually none of that file
comes from the original PPP code released by CMU.  This series solves
the problem by moving the code that I originally wrote to a new header
file with my copyright on it.

While we're at it, I also change the license on some files where I had
put an ANU copyright notice originally to have my copyright instead.
I have an acknowledgement in writing from September 2002 from ANU that
they do not claim any copyright in this code.
