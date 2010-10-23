Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab0JWUAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 16:00:18 -0400
Received: from cynthia.allandria.com ([76.245.85.235]:59402 "EHLO
	cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422Ab0JWUAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 16:00:15 -0400
Date: Sat, 23 Oct 2010 12:59:57 -0700
From: Brad Boyer <flar@allandria.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sanchit Garg <sancgarg@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] net/9p: Return error on read with NULL buffer
Message-ID: <20101023195957.GA13348@cynthia.pants.nu>
References: <1287412853-24700-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1287412853-24700-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287412853-24700-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 08:10:53PM +0530, Aneesh Kumar K.V wrote:
> This patch ensures that a read(fd, NULL, 0 ) returns  EFAULT on a 9p file.

Is there some specific reason you want this behavior? I believe the
generic Linux code returns success in this case. I tried this exact
system call with fd being a pty or a file on ext3 and got 0 for both.

	Brad Boyer
	flar@allandria.com

