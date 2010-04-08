Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab0DHU1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:27:55 -0400
Received: from kroah.org ([198.145.64.141]:42651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933333Ab0DHU1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:27:44 -0400
Date: Thu, 8 Apr 2010 12:33:21 -0700
From: Greg KH <greg@kroah.com>
To: Maurice Dawson <mauricedawson2699@googlemail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] Staging: comedi: fix macro coding style issue in
 adl_pci9111.c
Message-ID: <20100408193321.GK31571@kroah.com>
References: <1268229735-5387-1-git-send-email-mauricedawson2699@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268229735-5387-1-git-send-email-mauricedawson2699@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 02:02:15PM +0000, Maurice Dawson wrote:
> Patch to the adl_pci9111.c file that fixes, ERROR: Macros with multiple statements should be enclosed in a do - while block, found by the checkpatch.pl tool

Doesn't apply :(
