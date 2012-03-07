Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab2CGQqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:46:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:35879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2CGQqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:46:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="118699049"
Message-ID: <1331138861.3463.22.camel@sauron.fi.intel.com>
Subject: Re: Smatch v1.56 released
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        smatch@vger.kernel.org
Date: Wed, 07 Mar 2012 18:47:41 +0200
In-Reply-To: <20120305072220.GL22598@mwanda>
References: <20120304180455.GA1003@mwanda>
	 <1330886330.7070.22.camel@joe2Laptop> <20120305072220.GL22598@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 10:22 +0300, Dan Carpenter wrote:
> What I do is only look at new bugs.  I've got a script
> 	smatch_scripts/new_bugs.sh
> That takes the output from two smatch runs and prints the bugs which
> are new.
> 
> Artem has a set of scripts he's working on as well.

Yeah, I basically compile with W=1, run
sparse/coccinelle/cppcheck/smatch before and after a patch, compare the
build logs and report about only new warnings. Quite useful when you are
a maintainer.

-- 
Best Regards,
Artem Bityutskiy

