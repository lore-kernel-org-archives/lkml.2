Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030804Ab2COPBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:01:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60225 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030668Ab2COPBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:01:47 -0400
Date: Thu, 15 Mar 2012 16:01:41 +0100
From: Andrea Gelmini <andrea.gelmini@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fixup module.h usage as required
Message-ID: <20120315150141.GD6474@pambianco.com>
References: <1330305418-3507-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330305418-3507-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 08:16:58PM -0500, Paul Gortmaker wrote:
> Delete the instances of module.h that aren't actually used
> or needed.  Replace with export.h as required.

I'm using this patch without problem since you published it (compressed
/home with hourly snapshot delete/creation).

Thanks a lot for your work,
Andrea
