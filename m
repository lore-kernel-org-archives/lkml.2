Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2BRXp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 18:45:29 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47958 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753625Ab2BRXp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 18:45:28 -0500
Message-ID: <1329608726.1753.42.camel@joe2Laptop>
Subject: Re: [PATCH 3/3 v2] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
From: Joe Perches <joe@perches.com>
To: Jorgyano vieira <jorgyano@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, nsankar@broadcom.com, jarod@wilsonet.com
Date: Sat, 18 Feb 2012 15:45:26 -0800
In-Reply-To: <CABRD5hK5+aRg5eYJ4bQhUPfiSJcqc6_bc97z3y5r2nEogn-H3Q@mail.gmail.com>
References: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
	 <1329604310.1753.30.camel@joe2Laptop>
	 <CABRD5hKU0a-z8qd+xQEcHzH3y3eFy+sxUUtg1NXi+fqmbw4h4A@mail.gmail.com>
	 <1329606877.1753.37.camel@joe2Laptop>
	 <CABRD5hK5+aRg5eYJ4bQhUPfiSJcqc6_bc97z3y5r2nEogn-H3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-18 at 21:34 -0200, Jorgyano vieira wrote:
> this is the output after the patch:
> $ grep -rP --include=*.[ch] -m1 "^[ \t]*#[ \t]*include"
[]
> drivers/staging/crystalhd/crystalhd_lnx.c:#include "crystalhd_lnx.h"

So this is still 2 layers indirected.

It might make more sense to have a
#include "crystalhd.h"
have pr_fmt be the first #define in that and have
crystalhd.h be the first #include in everything.

