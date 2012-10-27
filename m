Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab2J0PGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:06:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57952 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab2J0PGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:06:03 -0400
Date: Sat, 27 Oct 2012 08:06:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yan Hong <clouds.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] debugfs: remove goto in debugfs_remount()
Message-ID: <20121027150649.GC3349@kroah.com>
References: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
 <1351325129-10097-5-git-send-email-clouds.yan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351325129-10097-5-git-send-email-clouds.yan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 04:05:29PM +0800, Yan Hong wrote:
> Simple code clean to remove goto.

There is nothing wrong with gotos on error paths, so this one should
stay.

greg k-h
