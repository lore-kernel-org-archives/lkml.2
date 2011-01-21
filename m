Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1AUSdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:33:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55614 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1AUSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:33:07 -0500
Date: Fri, 21 Jan 2011 18:33:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH] video: pxa168fb: remove a redundant pxa168fb_check_var
	call
Message-ID: <20110121183304.GA3075@sirena.org.uk>
References: <1295608686.3976.9.camel@phoenix> <201101211907.07386.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101211907.07386.marek.vasut@gmail.com>
X-Cookie: I like your SNOOPY POSTER!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 07:07:07PM +0100, Marek Vasut wrote:

> Please, don't use the get_maintainers script. This CCs too many people, really. 

*Using* get_maintainers.pl is fine, but it is important to apply taste
to the results since as you say it does generate false positives.
