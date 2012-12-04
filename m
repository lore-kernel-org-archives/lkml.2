Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2LDM7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:59:30 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39862 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2LDM72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:59:28 -0500
Date: Tue, 4 Dec 2012 04:59:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: checkpatch.pl and assembly #defines
Message-ID: <20121204125923.GA14294@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120412-7282-0000-0000-00000FAAF8EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andy,

The current checkpatch.pl complains about cpp macros defined as follows:

#define callit call my_function

Of course, if you do put parentheses around the definition, your assembler
will complain.  Could this complaint be downgraded to a warning?  Or is
there some way to recognize assembly cpp macros?

							Thanx, Paul

