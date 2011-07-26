Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1GZQum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:50:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54351 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1GZQug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:50:36 -0400
Date: Tue, 26 Jul 2011 17:50:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dan Carpenter <error27@gmail.com>
Cc: josef@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch] fs: add missing unlock in default_llseek()
Message-ID: <20110726165031.GH22133@ZenIV.linux.org.uk>
References: <20110726142520.GG3824@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726142520.GG3824@shale.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 05:25:20PM +0300, Dan Carpenter wrote:
> 
> A recent change in linux-next, 982d816581 "fs: add SEEK_HOLE and
> SEEK_DATA flags" added some direct returns on error, but it should
> have been a goto out.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied.
