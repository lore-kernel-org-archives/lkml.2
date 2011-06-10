Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1FJNsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:48:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34411 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab1FJNsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:48:45 -0400
Date: Fri, 10 Jun 2011 14:48:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm, exec: remove redundant set_fs(USER_DS)
Message-ID: <20110610134821.GL24424@n2100.arm.linux.org.uk>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com> <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org> <1307711337-4042-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307711337-4042-1-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 03:08:57PM +0200, Mathias Krause wrote:
> The address limit is already set in flush_old_exec() so this
> set_fs(USER_DS) is redundant.

Please show where and how this is done.  I've looked and can't see
any equivalent call to set_fs() in flush_old_exec().
