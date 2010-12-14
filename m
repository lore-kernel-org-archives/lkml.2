Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab0LNWSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:18:10 -0500
Received: from nat.scz.novell.com ([213.151.88.252]:51961 "EHLO pobox.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758045Ab0LNWSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:18:09 -0500
Date: Tue, 14 Dec 2010 23:18:08 +0100
From: Michal Marek <mmarek@suse.cz>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kbuild: fix interaction of CONFIG_IKCONFIG and
	KCONFIG_CONFIG
Message-ID: <20101214221808.GB8831@pobox.suse.cz>
References: <4D078D53.4040700@suse.cz> <98706bc370fe92e090b16c7ad91dce1cd2203acf.1292344590.git.bengardiner@nanometrics.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98706bc370fe92e090b16c7ad91dce1cd2203acf.1292344590.git.bengardiner@nanometrics.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 11:39:44AM -0500, Ben Gardiner wrote:
> If you try to build a kernel with KCONFIG_CONFIG set (to a value
> not equal to .config) and that config sets CONFIG_IKCONFIG then the
> build will fail with:
> 
> make[1]: *** No rule to make target `.config', needed by \
> `kernel/config_data.gz'.  Stop.
> 
> because the kernel/Makefile contains a direct reference to .config.
> 
> This issue has been present since the introduction of KCONFIG_CONFIG
> in 14cdd3c402bf7c66f0bcd76e290f0770a54a4b21.
> 
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> CC: Roman Zippel <zippel@linux-m68k.org>
> CC: Michal Marek <mmarek@suse.cz>
> Reviewed-by: Michal Marek <mmarek@suse.cz>
> 
> ---
> 
> changes since v1:
>  * rebased to 6313e3c21743cc88bb5bd8aa72948ee1e83937b6 of
>    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>  * export KCONFIG_CONFIG from top-level Makefile (Michal Marek)

Thanks, applied to kbuild-2.6.git#kbuild.

Michal
