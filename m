Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2DIUtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:49:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20702 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2DIUtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:49:31 -0400
Date: Mon, 9 Apr 2012 22:49:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
Subject: [PATCH 00/26] Remove redundant tests for NULL before calling
 release_firmware()
Message-ID: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a series of patches that removes redundant tests for a pointer 
being NULL before passing it to release_firmware().

Such checks are redundant since release_firmware() tests for a NULL 
pointer internally.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

