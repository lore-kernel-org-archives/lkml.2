Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2HXLmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:42:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2HXLmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:42:19 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v4 2/2] input: misc: New USB eBeam input driver.
Date: Fri, 24 Aug 2012 13:41:04 +0200
Message-ID: <1555763.Oi7gGGn7BU@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc2-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50374B69.3040002@laposte.net>
References: <1345673514-11575-1-git-send-email-yann.cantin@laposte.net> <1368810.q4rGz16CTW@linux-lqwf.site> <50374B69.3040002@laposte.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012 11:37:45 Yann Cantin wrote:
> Hi,
> 
> Le 23/08/2012 09:23, Oliver Neukum a écrit :
> > On Thursday 23 August 2012 00:11:54 Yann Cantin wrote:

> > These functions are identical. You should unify them.
> 
> Removed reset_resume from the driver (optional, and not needed
> for this hardware).

Why did you do that? It is always better to have reset_resume().
And you cannot tell whether it will be needed.

	Regards
		Oliver

