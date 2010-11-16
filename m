Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331Ab0KPMIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:08:11 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56532 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab0KPMIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:08:10 -0500
Date: Tue, 16 Nov 2010 21:08:08 +0900
From: Norbert Preining <preining@logic.at>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/sda disappearing with SYFS_DEPRECATED?
Message-ID: <20101116120808.GA28915@gamma.logic.tuwien.ac.at>
References: <20101116052027.GB24410@gamma.logic.tuwien.ac.at> <20101116055108.GB1064@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116055108.GB1064@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 16 Nov 2010, Paul Mundt wrote:
> Yes. Newer tools are incompatible with these settings, as noted in the
> Kconfig help for these entries:

Ouch, sorry, yes... didn't read that. I read only the short desc and hoped
that it might fix the input layer problem introduced in 2.6.37-rc, not 
giving me brightness events.

Thanks.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
One's never alone with a rubber duck.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
