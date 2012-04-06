Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2DFAAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:00:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab2DFAAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:00:25 -0400
Date: Thu, 5 Apr 2012 17:00:23 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 5/5] fbdev: s/#if CONFIG/#ifdef CONFIG/
In-Reply-To: <4F417B3F.2050307@gmx.de>
Message-ID: <alpine.LNX.2.00.1204051700010.9041@pobox.suse.cz>
References: <1329664319-3128-1-git-send-email-geert@linux-m68k.org> <1329664319-3128-5-git-send-email-geert@linux-m68k.org> <4F417B3F.2050307@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Feb 2012, Florian Tobias Schandinat wrote:

> On 02/19/2012 03:11 PM, Geert Uytterhoeven wrote:
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> 
> Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> (I assume you want that to go mainline via Jiri's tree)

As this doesn't seem to be in linux-next through any other tree as of 
today, I have picked it up.

Thanks,

-- 
Jiri Kosina
SUSE Labs
