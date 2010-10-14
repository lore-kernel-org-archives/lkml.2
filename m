Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0JNJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:58:25 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:42915 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754806Ab0JNJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:58:24 -0400
Date: Thu, 14 Oct 2010 11:47:57 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcmcia: fix unused function compile warning
Message-ID: <20101014094757.GA30271@comet.dominikbrodowski.net>
Mail-Followup-To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1287031634-25284-1-git-send-email-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287031634-25284-1-git-send-email-zenczykowski@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:47:14PM -0700, Maciej Żenczykowski wrote:
> pcmcia_socket_dev_resume() is only referenced from macro
> SET_SYSTEM_SLEEP_PM_OPS(NULL, pcmcia_socket_dev_resume)
> which based on CONFIG_PM_SLEEP may or may not actually
> use its second parameter.
> 
> Signed-off-by: Maciej Żenczykowski <zenczykowski@gmail.com>

Applied to the pcmcia git tree, thanks.

Best,
	Dominik
