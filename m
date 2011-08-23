Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1HWV23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:28:29 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54515 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183Ab1HWV2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:28:22 -0400
X-Sasl-enc: LkyBxn6vgq6IY+AAuimB10oh/8idHfm7pX+/Id3Znuwo 1314134902
Date: Tue, 23 Aug 2011 14:24:06 -0700
From: Greg KH <greg@kroah.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] staging: xgifb: delete an empty string
Message-ID: <20110823212406.GA828@kroah.com>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
 <1313782830-31461-13-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313782830-31461-13-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 10:40:30PM +0300, Aaro Koskinen wrote:
> Delete a string which is always empty.

This patch broke the build, please be more careful.

greg k-h
