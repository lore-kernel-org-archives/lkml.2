Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0HDBFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:05:07 -0400
Received: from ozlabs.org ([203.10.76.45]:54740 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0HDBFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:05:05 -0400
From: Michael Neuling <mikey@neuling.org>
To: Greg KH <gregkh@suse.de>
cc: michael@ellerman.id.au, linux-kernel@vger.kernel.org
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: git tree for testing stable kernels RCs
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 04 Aug 2010 11:05:04 +1000
Message-ID: <1527.1280883904@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Do you have a git tree with RC candidates for the stable kernels?  I'm
interested in full trees, not just the patch series like you have in
your stable-queue.git tree.  I'm happy if this tree is re-based before
the final stable release.

The reason I ask is that Michael Ellerman has added the stable kernels
to his list of trees he tests with his kisskb infrastructure.  You can
see the results here:

stable-2.6.27: http://kisskb.ellerman.id.au/kisskb/branch/19/
stable-2.6.32: http://kisskb.ellerman.id.au/kisskb/branch/17/
stable-2.6.34: http://kisskb.ellerman.id.au/kisskb/branch/15/
stable-2.6.35: http://kisskb.ellerman.id.au/kisskb/branch/16/

These results have already helped us find bugs but it would be even
better if we could fix the problems before the final release.

If you don't have this available we're likely to build one but before
we do, I thought I'd ask if you had this pre-built somewhere anyway.

Regards,
Mikey
