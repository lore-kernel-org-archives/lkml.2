Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2KTKZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:25:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2KTKZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:25:51 -0500
Date: Tue, 20 Nov 2012 11:25:50 +0100
From: Michal Marek <mmarek@suse.cz>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] kbuild: Remove reference to uninitialised variable
Message-ID: <20121120102550.GB31243@sepie.suse.cz>
References: <20121015124912.GA32257@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015124912.GA32257@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 01:49:12PM +0100, Charles Keepax wrote:
> Verbose output variable is unnecessary because the command's echo is
> already surpressed. Additionally because the block defines skip-makefile
> the variable Q is not defined within the makefile, which can cause
> problems if Q is defined in the users environment.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Applied to kbuild.git#kbuild, thanks.

Michal
