Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423037Ab2KNOmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:42:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50904 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422960Ab2KNOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:42:19 -0500
Date: Wed, 14 Nov 2012 17:40:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: devel@driverdev.osuosl.org, line6linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] staging: line6: replace DEBUG_MESSAGES() with
 dev_dbg()
Message-ID: <20121114144041.GI11515@mwanda>
References: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
 <1352638346-32273-2-git-send-email-stefanha@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352638346-32273-2-git-send-email-stefanha@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 01:52:24PM +0100, Stefan Hajnoczi wrote:
> +					dev_dbg(pod->line6.ifcdev,
> +						"wrong size of channel dump message (%d instead of %d)\n",
> +						pod->line6.message_length,
> +						(int)sizeof(pod->prog_data) +
> +						7);

Better to get rid of the cast.  You're already over the 80 character
limit so putting the "7);" on the line before is ok.

regards,
dan carpenter

