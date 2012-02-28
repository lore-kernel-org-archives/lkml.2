Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2B1AgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:36:24 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41500 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755363Ab2B1AgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:36:23 -0500
Message-ID: <1330389383.16334.22.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: do not try to sanity test cover letters
From: Joe Perches <joe@perches.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: apw@canonical.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Feb 2012 16:36:23 -0800
In-Reply-To: <1330388976-30633-1-git-send-email-paul.gortmaker@windriver.com>
References: <1330388976-30633-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 19:29 -0500, Paul Gortmaker wrote:
> One possibly common workflow is this:
> 
> 	git format-patch -o mypatches --cover-letter ^start end
> 	./scripts/checkpatch.pl mypatches/*

I use a script for this and don't put the check
in checkpatch but put the check in bash.


