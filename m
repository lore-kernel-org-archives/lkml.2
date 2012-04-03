Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2DCL3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:29:25 -0400
Received: from ra.se.axis.com ([195.60.68.13]:33943 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab2DCL3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:29:24 -0400
Date: Tue, 3 Apr 2012 13:29:19 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Mikael Starvik <starvik@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jirislaby@gmail.com" <jirislaby@gmail.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 1/1] cris: posix_types.h, include
	asm-generic/posix_types.h
Message-ID: <20120403112919.GQ21889@axis.com>
References: <1333366817-26121-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333366817-26121-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 01:40:17PM +0200, Jiri Slaby wrote:
> Without that I cannot build anything:
> In file included from include/linux/page-flags.h:8:0,
>                  from kernel/bounds.c:9:
> include/linux/types.h:25:1: error: unknown type name '__kernel_ino_t'
> include/linux/types.h:29:1: error: unknown type name '__kernel_off_t'
> ...
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: linux-cris-kernel@axis.com

Excellent, thanks, I'll take this into my newly resurrected
(due to disk failure) cris tree.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
