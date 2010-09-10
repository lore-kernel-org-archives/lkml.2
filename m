Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0IJQn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:43:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60486 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab0IJQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:43:55 -0400
Date: Fri, 10 Sep 2010 17:43:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] MFD: AB8500 debugfs
Message-ID: <20100910164352.GG23903@sirena.org.uk>
References: <1284134031-8979-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284134031-8979-1-git-send-email-mattias.wallin@stericsson.com>
X-Cookie: Here there be tygers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 05:53:51PM +0200, Mattias Wallin wrote:

> +config AB8500_DEBUG
> +	bool "Enable debug info via debugfs"
> +	depends on AB8500_CORE && DEBUG_FS
> +	default y
> +	help
> +	  Select this option if you want debug information using the debug
> +	  filesystem, debugfs.
> +

Might it be sensible to just unconditionally enable this if debugfs is
enabled?
