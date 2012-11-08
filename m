Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab2KHVoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:44:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab2KHVoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:44:06 -0500
Date: Thu, 8 Nov 2012 22:44:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Valentin Ilie <valentin.ilie@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: panic.c
In-Reply-To: <1352033273-19558-1-git-send-email-valentin.ilie@gmail.com>
Message-ID: <alpine.LNX.2.00.1211082243280.27271@pobox.suse.cz>
References: <1352033273-19558-1-git-send-email-valentin.ilie@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2012, Valentin Ilie wrote:

> Fixed checkpatch warnings.
> Replaced printk(KERN_WARNING with pr_warn

The changelog is not really accurate, you are replacing _EMERG as well. 
Plus the missing closing bracket is not visually nice :)

-- 
Jiri Kosina
SUSE Labs
