Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2KEONX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:13:23 -0500
Received: from gherkin.frus.com ([192.158.254.49]:60891 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2KEONT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:13:19 -0500
X-Greylist: delayed 1203 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2012 09:13:19 EST
Date: Mon, 5 Nov 2012 07:53:13 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: mcree@orcon.net.nz
Subject: 3.7.0-rc4 build failure on alpha: MPILIB
Message-ID: <20121105135313.GA3979@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With digital signature verification support (SIGNATURE, MPILIB) enabled
on the Alpha platform, I get the following during the MODPOST section of
the build:

ERROR: "__udiv_qrnnd" [lib/mpi/mpi.ko] undefined!

Current compiler is gcc-4.6.3

-- 
------------------------------------------------------------------------
Bob Tracy          |  "Build a man a fire, he'll be warm for a day.  Set
rct@frus.com       |   a man on fire, he'll be warm for the rest of his
                   |   life."	-- David Burge (Iowahawk)
------------------------------------------------------------------------
