Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab1ADKZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:25:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:47348 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab1ADKZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:25:34 -0500
Date: Tue, 4 Jan 2011 11:25:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Ott <alan@signal11.us>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Antonio Ospite <ospite@studenti.unina.it>, Tejun Heo <tj@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hidraw: Added Compatibility ioctl() for 32-bit
 applications.
In-Reply-To: <201101041118.39602.arnd@arndb.de>
Message-ID: <alpine.LNX.2.00.1101041125240.26685@pobox.suse.cz>
References: <1294119442-6827-1-git-send-email-alan@signal11.us> <1294119442-6827-2-git-send-email-alan@signal11.us> <201101041118.39602.arnd@arndb.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011, Arnd Bergmann wrote:

> On Tuesday 04 January 2011 06:37:22 Alan Ott wrote:
> > Added the ioctl function to the compat_ioctl pointer in the
> > file_operations struct. Before this, some ioctls would 
> > fail for 32-bit apps on 64-bit systems.
> > 
> > Signed-off-by: Alan Ott <alan@signal11.us>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks guys.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
