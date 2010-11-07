Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0KGK31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 05:29:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44965 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0KGK30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 05:29:26 -0500
Date: Sun, 7 Nov 2010 11:29:02 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drivers: edac: Makfile: Cleaned up Makefile
Message-ID: <20101107102902.GA7230@aftab>
References: <1289070307-2563-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289070307-2563-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 03:05:07PM -0400, Tracey Dent wrote:
> Changed Makefile to use <modules>-y instead of <modules>-objs.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>

While I don't object the change, I think your commit message should be
fixed not to say _what_ your patch changes (we can see that) but to say
_why_ you're making that change. See, I had to go search lkml just to
find why all of a sudden <..>-objs is being changed.

So please go and add text explaining that -objs is deprecated and so on.
And make sure you've checked out Documentation/SubmittingPatches - it'll
save you a lot of trouble in the future :).

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
