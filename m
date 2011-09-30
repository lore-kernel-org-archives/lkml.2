Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1I3M6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:58:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48565 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717Ab1I3M6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:58:48 -0400
Date: Fri, 30 Sep 2011 13:58:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/4] regmap: Lock the sync path, ensure we use the
 lockless _regmap_write()
Message-ID: <20110930125846.GM5366@opensource.wolfsonmicro.com>
References: <1317303388-4040-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317303388-4040-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 02:36:25PM +0100, Dimitris Papastamos wrote:
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

Applied all, thanks.

If you're finding your commit subjects are getting as long as this one
you really should be writing a longer commit body rather than trying to
squeeze everything into the subject.
