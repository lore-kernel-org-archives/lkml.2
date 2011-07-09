Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1GIVSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:18:11 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13215 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1GIVSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:18:08 -0400
Date: Sat, 9 Jul 2011 23:08:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
Subject: [PATCH 0/7] static should be at beginning of declaration
Message-ID: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-735625818-1310245711=:25516"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-735625818-1310245711=:25516
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Here's a small series of patches that ake sure that the 'static' keywork 
is at the beginning of declarations.

This gets rid of warnings like
  warning: ¡static¢ is not at beginning of declaration
when building with -Wold-style-declaration (and/or -Wextra which also
enables it).

I've cleaned out a number of these in the past and this patch set 
represents the last few remaining offenders in the entire tree.

All patches will be sent as replies to this mail.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-735625818-1310245711=:25516--
