Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2CXW0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:26:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab2CXW0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:26:51 -0400
Date: Sat, 24 Mar 2012 23:26:49 +0100
From: Michal Marek <mmarek@suse.cz>
To: Josh Boyer <jwboyer@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>, kernel-team@fedoraproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] merge_config.sh: Use the first file as the initial config
Message-ID: <20120324222649.GB8947@sepie.suse.cz>
References: <20120201170157.GA4907@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201170157.GA4907@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 12:01:58PM -0500, Josh Boyer wrote:
> Take the first config fragment and use it verbatim as the initial config set.
> This avoids running the verification loop for the first file, as nothing has
> actually been merged at this point.  This significantly increases performance
> for large config fragments.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Applied to kbuild.git#kconfig, thanks.

Michal
