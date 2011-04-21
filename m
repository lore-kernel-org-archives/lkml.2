Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1DUGw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:52:26 -0400
Received: from mail.perches.com ([173.55.12.10]:4863 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1DUGwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:52:25 -0400
Subject: Re: [PATCH] tg3: Convert u32 flag,flg2,flg3 uses to bitmap
From: Joe Perches <joe@perches.com>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <02bf2aa5c08514641ecbe7c39ef976918fad036c.1303367730.git.joe@perches.com>
References: <1303322263-18991-10-git-send-email-mcarlson@broadcom.com>
	 <02bf2aa5c08514641ecbe7c39ef976918fad036c.1303367730.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 23:52:23 -0700
Message-ID: <1303368743.24766.47.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 23:39 -0700, Joe Perches wrote:
> Using a bitmap instead of separate u32 flags allows a consistent, simpler
> and more extensible mechanism to determine capabilities.

This is the second version of this patch.

I sent Matt privately a version a couple of weeks ago
to get his opinion before posting this one.

David, please don't apply unless/until Matt acks this.
It compiles but is untested here.

