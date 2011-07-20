Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab1GTFT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 01:19:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54598 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1GTFT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 01:19:57 -0400
Subject: Re: Regression in handling of unsafe UBI shutdown
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Daniel Mack <zonque@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sven Neumann <s.neumann@raumfeld.com>,
        Adrian Hunter <adrian.hunter@nokia.com>
Date: Wed, 20 Jul 2011 08:21:18 +0300
In-Reply-To: <CACTFLANAFT=G4kFvHUqvLrt=MxgpJnJ-EeHY8zd49pZvsNRejw@mail.gmail.com>
References: <CACTFLANAFT=G4kFvHUqvLrt=MxgpJnJ-EeHY8zd49pZvsNRejw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1311139283.20738.150.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 15:57 +0200, Daniel Mack wrote:
> UBIFS: recovery needed
> Error reading superblock on volume 'ubi:RootFS'!
> UBIFS not mounted, use ubifs mount to mount volume first!
> Wrong Image Format for bootm command
> ERROR: can't get kernel image!
> 
> 
> Hence my question is: were there any radical changes in the UBI/UBIFS
> code on the kernel side that make older code not like the new content
> anymore?

Daniel, sorry, I have no time to look at this now, could you please try
to bisect the issue?

-- 
Best Regards,
Artem Bityutskiy

