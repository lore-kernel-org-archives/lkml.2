Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2GMUy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:54:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab2GMUy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:54:56 -0400
Date: Fri, 13 Jul 2012 22:54:53 +0200
From: Michal Marek <mmarek@suse.cz>
To: cody@linux.vnet.ibm.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kconfig: allow long lines in config file
Message-ID: <20120713205447.GA5160@pobox.suse.cz>
References: <50001D87.1020708@suse.cz> <1342204033-24484-1-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342204033-24484-1-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:27:12AM -0700, cody@linux.vnet.ibm.com wrote:
> From: Cody Schafer <cody@linux.vnet.ibm.com>
> 
> For some config options (CONFIG_EXTRA_FIRMWARE, for example), the length
> of a config file line can exceed the 1024 byte buffer.
> 
> Switch from fgets to compat_getline to fix. compat_getline is an
> internally implimented getline work-alike for portability purposes.
> 
> Signed-off-by: Cody Schafer <cody@linux.vnet.ibm.com>

Applied to kbuild.git#kconfig, thanks.

Michal
