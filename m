Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1ILQrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:47:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64825 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab1ILQrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:47:36 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wm831x-spi: use id_table rather hand rolled variant handling
References: <1315842302-27607-1-git-send-email-jacmet@sunsite.dk>
	<20110912163812.GE5887@opensource.wolfsonmicro.com>
Date: Mon, 12 Sep 2011 18:47:32 +0200
In-Reply-To: <20110912163812.GE5887@opensource.wolfsonmicro.com> (Mark Brown's
	message of "Mon, 12 Sep 2011 17:38:12 +0100")
Message-ID: <87pqj57lnf.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mark" == Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

Hi,

 Mark> Non-bugfix patches like this should always be submitted against the
 Mark> latest code in -next unless the subsystem is being unusual.  I can tell
 Mark> you're not working against the latest -next becuase it has a version of
 Mark> this in it already.  :)

Argh, sorry - I just noticed it while looking at something else in mfd/.

-- 
Bye, Peter Korsgaard
