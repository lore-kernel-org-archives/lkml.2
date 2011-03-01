Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1CALUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:20:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60536 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab1CALUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:20:42 -0500
Date: Tue, 1 Mar 2011 11:20:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] MAINTAINERS: Remove unnecessary
	linux-kernel@vger.kernel.org entries
Message-ID: <20110301112038.GA12568@sirena.org.uk>
References: <cover.1298439175.git.joe@perches.com> <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
X-Cookie: Who's scruffy-looking?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:41:58PM -0800, Joe Perches wrote:
> CC'ing lkml is the default and doesn't need separate entries.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I've run into a noticable number of issues with users not parsing this
convention as expected and sending only direct to maintainer mail for
things that have no list.  For the amount of space it saves in the file
I'm not sure it's worth removing such entries.
