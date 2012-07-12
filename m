Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab2GLIgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:36:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39313 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2GLIg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:36:28 -0400
Date: Thu, 12 Jul 2012 11:36:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Francois Romieu <romieu@fr.zoreil.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/et131x: remove memset for the TCB
Message-ID: <20120712083610.GE6056@mwanda>
References: <1342073368-11893-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342073368-11893-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 11:54:28AM +0545, Devendra Naga wrote:
> TCB has kcalloc' ed so no need to call memset again on it.
> 

Gar...  What about when this is called from et131x_adjust_link() and
et1310_disable_phy_coma()?

Really this changelog is annoying.  Based on the changelog I was
expecting the kcalloc() to be in the same function but it wasn't.
So then I have to redo all your work and check every code path.  You
could have said what the code paths were in your description so I
don't have to grovel through it all myself.

regards,
dan carpenter


