Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2JAS04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:26:56 -0400
Received: from quechua.inka.de ([193.197.184.2]:41942 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab2JAS0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:26:55 -0400
X-Greylist: delayed 1154 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2012 14:26:54 EDT
Date: Mon, 01 Oct 2012 20:07:33 +0200
To: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_EXPERT is a booby trap
References: <50690CFE.6010600@xenotime.net> <E1TIXga-0008T1-00@www.xplot.org>
Organization: private Linux site, southern Germany
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: Olaf Titz <olaf@bigred.inka.de>
Message-ID: <E1TIkOz-0005p0-Ra@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <E1TIXga-0008T1-00@www.xplot.org> you write:
> Interestingly, of the 26 configs that use EXPERT in the default
> clause, 15 of them are in drivers/hid (see below).

Without looking at the code I assume this is due to copy/paste.
Someone perhaps once wrote

> ./drivers/hid/Kconfig:  default !EXPERT

when he really intended

> ./drivers/media/common/tuners/Kconfig:  default y if !EXPERT

Olaf
