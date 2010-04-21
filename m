Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0DUVaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:30:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab0DUVaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:30:10 -0400
Date: Wed, 21 Apr 2010 23:30:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Bastien Nocera <hadess@hadess.net>
Cc: Cory Fields <FOSS@AtlasTechnologiesInc.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] hid: Remove annoying non-error printk
In-Reply-To: <1271884643.17421.4098.camel@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1004212329470.7579@pobox.suse.cz>
References: <1271884104-31884-1-git-send-email-FOSS@AtlasTechnologiesInc.com> <1271884643.17421.4098.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010, Bastien Nocera wrote:

> > This is the only line printed on my "quiet" boot and seems completely
> > unnecessary.
> 
> Probably left-over from a debug run...
> 
> > Signed-off-by: Cory Fields <FOSS@AtlasTechnologiesInc.com>
> Signed-off-by: Bastien Nocera <hadess@hadess.net>

Applied, thank you guys.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
