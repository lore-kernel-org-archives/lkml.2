Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab1JXWc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:32:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33110 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318Ab1JXWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:32:26 -0400
Date: Tue, 25 Oct 2011 00:32:24 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] h8300: Move gpio.h to gpio-internal.h
Message-ID: <20111024223223.GA4351@opensource.wolfsonmicro.com>
References: <1319493561-4094-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20111024221004.GE4394@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024221004.GE4394@ponder.secretlab.ca>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:10:04AM +0200, Grant Likely wrote:

> This of course should go via the h8300 tree instead of the gpio tree.

If you look at the commit history there's not been much h8300 specific
work going on for quite some time now - all the commits have been going
via other trees - so since it's basically a gpiolib cleanup I figure
it'd be less work for Sato-san if you were able to pick it up.
