Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624Ab2B2AqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:46:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50300 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966212Ab2B2AqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:46:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.211.202 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Tue, 28 Feb 2012 16:46:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Input: atkbd - Add force relese key quirk for HP ProBook
Message-ID: <20120229004604.GB21093@kroah.com>
References: <1330475770-4153-1-git-send-email-manoj.iyer@canonical.com>
 <1330475770-4153-2-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330475770-4153-2-git-send-email-manoj.iyer@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 06:36:10PM -0600, Manoj Iyer wrote:
> HP ProBooks do not send a key release for brightness keys, as a
> result, brightness does not move up/down when the brightness key
> is held down. This quirk makes the brightness keys on HP ProBooks
> typematic.
> 
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> ---
>  drivers/input/keyboard/atkbd.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
