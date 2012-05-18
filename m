Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946337Ab2ERXr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:47:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41167 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946177Ab2ERXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:47:55 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] GPIO/TCA6424: merge I2C transactions, remove cast
To: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org
In-Reply-To: <20120518234410.E079C3E07C8@localhost>
References: <0M9AKX-1SNwZq1JrJ-00CWsH@mrelayeu.kundenserver.de> <20120518234410.E079C3E07C8@localhost>
Date: Fri, 18 May 2012 17:47:54 -0600
Message-Id: <20120518234754.1DD013E07C8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012 17:44:10 -0600, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, 18 May 2012 17:01:36 +0200, Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com> wrote:
> > From 1a80280e20dfef57c6bc6429e5bdf7e10d10fda9 Mon Sep 17 00:00:00 2001
> > From: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
> > Date: Fri, 18 May 2012 16:20:31 +0200
> > Subject: [PATCH] GPIO/TCA6424: merge I2C transactions, remove cast
> > 
> > This is a follow-up to "[PATCH v2] Add support for TCA6424":
> > - Use 3 byte transfers instead of two separate transfers (2+1 byte)
> > - An unnecessary cast removed
> > 
> > Please check especially if endianness conversion is done the way it should be.
> 
> It works I suppose.  Personally, I'd explicitly use a byte array, but
> I'll apply this patch as-is anyway.

Patch is damaged and cannot be applied (line wraps and tabs converted
to spaces).  Please check your mailer (please use git send-email) and
repost.

g.

