Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2LDUo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:44:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2LDUoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:44:24 -0500
Date: Tue, 4 Dec 2012 20:44:21 +0000
From: Andy Whitcroft <apw@canonical.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl and assembly #defines
Message-ID: <20121204204421.GU30773@dm>
References: <20121204125923.GA14294@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121204125923.GA14294@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 04:59:23AM -0800, Paul E. McKenney wrote:
> Hello, Andy,
> 
> The current checkpatch.pl complains about cpp macros defined as follows:
> 
> #define callit call my_function
> 
> Of course, if you do put parentheses around the definition, your assembler
> will complain.  Could this complaint be downgraded to a warning?  Or is
> there some way to recognize assembly cpp macros?

Well all checkpatch output is warnings anyhow.  Where are these being
placed, perhaps there is a clue in that at least.

-apw
