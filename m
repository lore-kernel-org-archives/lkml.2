Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2HaPbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 11:31:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab2HaPba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 11:31:30 -0400
Date: Fri, 31 Aug 2012 17:31:28 +0200
From: Michal Marek <mmarek@suse.cz>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: scripts/tags.sh: Add magic for pci access functions
Message-ID: <20120831153128.GF11531@sepie.suse.cz>
References: <624341345801828@web28e.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <624341345801828@web28e.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 01:50:28PM +0400, Kirill Tkhai wrote:
> scripts/tags.sh: Add magic for pci access functions
> 
> Make [ce]tags find the pci_bus_read_config_* and pci_bus_write_config_*
> definitions
> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>

Applied to kbuild.git#misc, thanks.

Michal
