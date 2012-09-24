Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2IXKwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:52:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18832 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2IXKwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:52:37 -0400
Date: Mon, 24 Sep 2012 13:52:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gorskin Ilya <revent82@gmail.com>
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:bcm: fix coding style issue in Bcmchar.c
Message-ID: <20120924105226.GI13767@mwanda>
References: <1348483483-32545-1-git-send-email-revent82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348483483-32545-1-git-send-email-revent82@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 04:44:43PM +0600, Gorskin Ilya wrote:
> This is a patch to the Bcmchar.c file that fixes up a coding style
> warning found by the checkpatch.pl tool
> 

The right way to fix this is to choose better variable names and to
get rid of the bogus BCM_DEBUG_PRINT() macro.  It's better to leave
the warnings in for now.

checkpatch.pl is not the king of us.

regards,
dan carpenter

