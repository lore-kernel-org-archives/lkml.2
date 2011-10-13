Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab1JMQNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:13:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab1JMQNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:13:06 -0400
Date: Thu, 13 Oct 2011 18:13:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH] [TRIVIAL] cris: remove
 arch/cris/arch-v32/lib/nand_init.S
In-Reply-To: <20111013113818.GT9412@axis.com>
Message-ID: <alpine.LNX.2.00.1110131812510.14768@pobox.suse.cz>
References: <1318504346.8345.23.camel@x61.thuisdomein> <20111013113818.GT9412@axis.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Jesper Nilsson wrote:

> On Thu, Oct 13, 2011 at 01:12:26PM +0200, Paul Bolle wrote:
> > Commit 3f50c0673cf5edd2c6bb76243410c3cd59b3b62d ("CRIS v32: Update
> > boot/rescue/head.S code") removed the last reference to that file. So
> > this file is unused since v2.6.25.
> 
> Aye, nothing uses this anymore.
> 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

Thanks, I am queueing it.

-- 
Jiri Kosina
SUSE Labs
