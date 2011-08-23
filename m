Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1HWTCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:02:18 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45160 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755102Ab1HWTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:01:51 -0400
X-Sasl-enc: DSBtsxiZRGQiMBVlNvbG+ZutRGTdwr14vlaXr6xCyGvk 1314126109
Date: Tue, 23 Aug 2011 11:57:38 -0700
From: Greg KH <greg@kroah.com>
To: Pelle Windestam <iceaway@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: comedi: changed local function prototype
 from extern to static.
Message-ID: <20110823185738.GA11772@kroah.com>
References: <1314009585-5025-1-git-send-email-iceaway@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314009585-5025-1-git-send-email-iceaway@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 12:39:45PM +0200, Pelle Windestam wrote:
> Changed local function prototype do_become_nonbusy(...) from extern to
> static, fixing the error from checkpatch.pl.
> 
> Signed-off-by: Pelle Windestam <iceaway@gmail.com>

Sorry, someone just beat you to this same change :(

