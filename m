Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0KFMBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 08:01:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38624 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0KFMBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 08:01:50 -0400
Message-ID: <4CD54341.4050109@ru.mvista.com>
Date: Sat, 06 Nov 2010 15:00:01 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] IDE: ide-floppy, remove unnecessary NULL check
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz> <1289034412-24278-3-git-send-email-jslaby@suse.cz>
In-Reply-To: <1289034412-24278-3-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06-11-2010 12:06, Jiri Slaby wrote:

> Stanse founf that rq in ide_floppy_callback cannot be NULL, because it

    found?

> is dereferenced all around. So remove the superfluous check.

> This appeared after blk_* macors removal.

    macros?

> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Cc: Christoph Hellwig<hch@lst.de>
> Cc: "David S. Miller"<davem@davemloft.net>
> Cc: linux-ide@vger.kernel.org

MBR, Sergei
