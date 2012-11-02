Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2KBGz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 02:55:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18447 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2KBGz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 02:55:58 -0400
Date: Fri, 2 Nov 2012 09:55:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, syahn@gctsemi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: wm_ioctl.h: fixed a macro coding style
Message-ID: <20121102065555.GC32762@mwanda>
References: <1351838579-24511-1-git-send-email-gmate.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351838579-24511-1-git-send-email-gmate.amit@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 11:42:59PM -0700, Kumar Amit Mehta wrote:
> fix for macro coding style.
> 

No.  The parenthesis are not needed.  I assume this is a
checkpatch.pl warning?

regards,
dan carpenter

