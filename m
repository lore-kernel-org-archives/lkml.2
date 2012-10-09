Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2JIIq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 04:46:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35887 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2JIIqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 04:46:24 -0400
Date: Tue, 9 Oct 2012 11:46:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [staging][zram] Fix handling of incompressible pages
Message-ID: <20121009084607.GA4587@mwanda>
References: <1349746364-8051-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349746364-8051-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 06:32:44PM -0700, Nitin Gupta wrote:
> Change 130f315a introduced a bug in the handling of incompressible
         ^^^^^^^^
When you mention a patch, please include the human readable patch
title as well as the hash.  "staging: zram: remove special handle of
uncompressed page".

regards,
dan carpenter

