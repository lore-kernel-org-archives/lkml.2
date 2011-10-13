Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1JMLiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:38:25 -0400
Received: from ra.se.axis.com ([195.60.68.13]:37576 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab1JMLiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:38:24 -0400
Date: Thu, 13 Oct 2011 13:38:18 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH] [TRIVIAL] cris: remove
	arch/cris/arch-v32/lib/nand_init.S
Message-ID: <20111013113818.GT9412@axis.com>
References: <1318504346.8345.23.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318504346.8345.23.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 01:12:26PM +0200, Paul Bolle wrote:
> Commit 3f50c0673cf5edd2c6bb76243410c3cd59b3b62d ("CRIS v32: Update
> boot/rescue/head.S code") removed the last reference to that file. So
> this file is unused since v2.6.25.

Aye, nothing uses this anymore.

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
