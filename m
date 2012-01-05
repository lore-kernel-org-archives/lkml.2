Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab2AECXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:23:51 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:58191 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670Ab2AECXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:23:48 -0500
Date: Wed, 4 Jan 2012 21:23:46 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/ext4: add missing ext4_resize_end
Message-ID: <20120105022346.GB24494@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Djalal Harouni <tixxdz@opendz.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
References: <20111222150057.GA10845@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222150057.GA10845@dztty>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 04:00:57PM +0100, Djalal Harouni wrote:
> Online resize ioctls 'EXT4_IOC_GROUP_EXTEND' and 'EXT4_IOC_GROUP_ADD'
> call ext4_resize_begin() to check permissions and to set the
> EXT4_RESIZING bit lock, they do their work and they must finish with
> ext4_resize_end() which calls clear_bit_unlock() to unlock and to
> avoid -EBUSY errors for the next resize operations.
> 
> This patch adds the missing ext4_resize_end() calls on error paths.
> 
> Patch tested.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>

Applied, thanks.

					- Ted
