Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1AQHUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 02:20:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40067 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1AQHUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 02:20:04 -0500
Date: Mon, 17 Jan 2011 07:20:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/inode.c: include "internal.h" for external definitions
Message-ID: <20110117072002.GH22723@ZenIV.linux.org.uk>
References: <0D753D10438DA54287A00B027084269764CE0E54E1@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764CE0E54E1@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 06:21:59PM -0600, H Hartley Sweeten wrote:
[snip]

Fix your MUA, please.  What you've somehow managed to produce was

Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

and git-am is not happy with it, to put it mildly.  I can work around
that (view as attachment in mutt, save that, etc.) and if that had been
anything more inspiring I'd bothered to undo the wreckage, apply by
hand and recall how to tell git commit who's the author, but...

Why had your MUA done that, anyway?  I don't see anything in the text
that might have possibly warranted something that weird...

	Al "tempted to reply with Content-Transfer-Encoding: morse" Viro
