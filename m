Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1EJIQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:16:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1EJIQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:16:10 -0400
Date: Tue, 10 May 2011 10:16:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5 v2]Typo: change kenrel to kernel.
In-Reply-To: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1105101015440.28291@pobox.suse.cz>
References: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Apr 2011, Justin P. Mattock wrote:

> The below patch is a resend due to rebasing to the current Mainline, in
> of which changes a typo "kenrel" to "kernel".

I have folded all the patches into one, dropped the staging/ bits (which 
wouldn't apply in -next anyway), and applied.

-- 
Jiri Kosina
SUSE Labs
