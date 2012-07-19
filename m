Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2GSWzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:55:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39867 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2GSWzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:55:53 -0400
Date: Thu, 19 Jul 2012 23:55:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: jan.bannister@gmail.com
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: acct.c:  spaces required around that '<'
Message-ID: <20120719225550.GX31729@ZenIV.linux.org.uk>
References: <1342732227-13972-1-git-send-email-jan.bannister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342732227-13972-1-git-send-email-jan.bannister@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 10:10:27PM +0100, jan.bannister@gmail.com wrote:
> From: Jan Bannister <jan.bannister@gmail.com>
> 
> Fixed a coding style issue

NAK, because I'm sick and tired of the pompous commit messages.  I'm fine
with adding those spaces.  However, I _do_ have a lot against the commit
messages like that.  "Required"?  By whom?  Holy checkpatch.pl?  "Coding
style issue" - completely uninformative; there all kinds of those.

FWIW, my prefernce would be something along the lines of "whitespace
tidy-up in <function or file name>".  At least that says what happens
in commit and where is it happening...
