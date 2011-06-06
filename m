Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1FFVH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:07:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38894 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1FFVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:07:56 -0400
Date: Mon, 6 Jun 2011 22:07:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] seq_file.h: introduce DECLARE_SEQ_FOPS_{RO,RW}
Message-ID: <20110606210755.GL11521@ZenIV.linux.org.uk>
References: <201106061319.45855.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106061319.45855.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 01:19:45PM -0700, H Hartley Sweeten wrote:
> Many of the procfs and debugfs attribute file_operations in the kernel are
> missing the .owner information. Introduce some macro's to fill in the .owner
> field as well as the common methods for virtual file file_operations.  This
> simplifies creating the attributes and makes sure all the fields are properly
> initialized.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Nacked-by: Al Viro <viro@zeniv.linux.org.uk>
Nacked-because: too ugly

Don't play that kind of games with preprocessor.
