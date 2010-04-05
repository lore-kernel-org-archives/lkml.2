Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab0DEGpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 02:45:51 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:43244 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab0DEGpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 02:45:45 -0400
Date: Mon, 5 Apr 2010 08:45:44 +0200
From: Andreas Mohr <andi@lisas.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc3: Can't insmod after make, because versions now
	differ?!
Message-ID: <20100405064544.GA22355@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405053628.GA12217@elf.ucw.cz>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Having to reboot every time I recompile the module or play with git
> makes modules useless for development :-(.

Confirmed. -rc3 (from 2.6.33 - sorry) was the only kernel I ever
observed this on (I simply changed a driver and redid make modules_install,
boom, version string (/lib/modules/...) changed from 2.6.34-rc3 to
2.6.34-rc3-...-dirty, despite having kept my git unupdated and on the
2.6.34-rc3 tag.

Andreas Mohr
