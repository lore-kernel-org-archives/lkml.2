Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1LZPto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 10:49:44 -0500
Received: from lo.gmane.org ([80.91.229.12]:41155 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab1LZPtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 10:49:43 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] kbuild: add Makefile snippet to list compiled files
Date: Mon, 26 Dec 2011 15:49:28 +0000 (UTC)
Message-ID: <jda527$j9o$1@dough.gmane.org>
References: <20111207062524.GA6570@faui49.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 180.129.255.227
User-Agent: slrn/0.9.9p1 (Linux)
Cc: linux-kbuild@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Dec 2011 at 06:25 GMT, Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de> wrote:
> To list the compilation units compiled by the current configuration the
> scripts/Makefile.list can be executed. It supports:
>
> - printing of all compilation units
> - all directories considered for compilation units
> - test if a given file is compiled by the configuration
> - use a different auto.conf
>

It would be nice if it can list the files complied for some
object or module. Sometimes, people wants to know which files
are compiled for some module.

Thanks.

