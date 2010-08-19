Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab0HSNU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:20:28 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:35083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0HSNU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:20:26 -0400
Subject: kernel-doc problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 15:20:19 +0200
Message-ID: <1282224019.4507.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy, all,

I'm running into a problem where something that I want to be part of a
description of a struct member or function parameter gets parsed as a
new section. You can easily see the problem by running below test file
through kernel-doc, clearly the intent is not to have a new section in
the middle of function argument descriptions, but I have no idea how I
could fix this.

I'd appreciate if you could take a look.

Thanks,
Johannes

--- here's the file ---
/**
 * fn - test
 *
 * @a: This is just a non-sense and totally useless dummy function
 *	argument: it has absolutely no effect.
 */
void fn(int a)
{
}


