Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1DJPJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:09:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:55203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab1DJPJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:09:19 -0400
Date: Sun, 10 Apr 2011 08:09:18 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/6]Fix typo "recieve" in various parts of the kernel.
In-Reply-To: <1302192567-842-2-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1104082004110.6392@deuxcents.site>
References: <1302192567-842-1-git-send-email-justinmattock@gmail.com> <1302192567-842-2-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Justin P. Mattock wrote:

> The patch below fixes "recieve" in various parts of the kernel.
> Note: patches 2,3,4,5 are fixes to comments only(no code).

Most of the occurences have been removed by 25985edcede ("Fix common 
misspellings").

So if you are able to spot anything still pending, please rebase and 
resend.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

