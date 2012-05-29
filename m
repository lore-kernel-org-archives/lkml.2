Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2E2GaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:30:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22072 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2E2GaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:30:09 -0400
Date: Tue, 29 May 2012 09:29:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: cb_pcidas64: Fixed coding style errors
 and an if-statement
Message-ID: <20120529062955.GB21008@mwanda>
References: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 09:28:35PM +0300, Dimitrios Semitsoglou-Tsiapos wrote:
> Fixed a few coding style errors and an if-statement responsible for a
> sanity check inside the prep_ao_dma function.
> 

I the change to the if statement is correct but it needs to be
resent in it's own patch.  We want the fix to be noticeable in the
change log.  Don't mix code changes and cleanups.

regards,
dan carpenter

