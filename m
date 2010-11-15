Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab0KOO6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:58:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:41039 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab0KOO6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:58:10 -0500
Date: Mon, 15 Nov 2010 15:58:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tracey Dent <tdent48227@gmail.com>
Cc: dmitry.torokhov@gmail.com, chatty@enac.fr, spbnick@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Drivers: hid: Makefile: Cleaned up Makefile
In-Reply-To: <1289141188-1447-1-git-send-email-tdent48227@gmail.com>
Message-ID: <alpine.LNX.2.00.1011151557510.7420@pobox.suse.cz>
References: <1289141188-1447-1-git-send-email-tdent48227@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Tracey Dent wrote:

> Changed Makefile to use <modules>-y instead of <modules>-objs because 
> -objs is deprecated and should now be switched. According to 
> (documentation/kbuild/makefiles.txt).

Actually, where exactly does this file document it?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
