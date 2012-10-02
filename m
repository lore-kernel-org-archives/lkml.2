Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2JBMPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:15:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16850 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2JBMPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:15:10 -0400
Date: Tue, 2 Oct 2012 15:14:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: joe@perches.com, gregkh@linuxfoundation.org, davem@davemloft.net,
        arnd@arndb.de, elezegarcia@gmail.com, Julia.Lawall@lip6.fr,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH RFC] MAINTAINERS: Add section for subsystem shortname
Message-ID: <20121002121443.GT4587@mwanda>
References: <1349179024-5319-1-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349179024-5319-1-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 01:57:04PM +0200, Peter Senna Tschudin wrote:
> The shortname for a subsystem, that is primarly used when sending patches over E-mail, is not stored anywhere in the source code. Actually one need to dig git log or mailing list archives. There is no standard, and the Maintainer choose how to short name his/her subsystem. MAINTAINERS file is the right place for storing this information.
> 
> U is the second letter of Subsystem.
> 
> This will also enable automatic tools like scripts/get_maintainer.pl to provide the correct short name for each filename in the Kernel source tree.
> 

This is pretty useless without a script to parse it.  Also none of
subsystem names you chose as examples are correct.  Please line wrap
your commit message at 72 characters.

regards,
dan carpenter

