Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1BUUe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:34:57 -0500
Received: from mx2.parallels.com ([64.131.90.16]:33259 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab1BUUe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:34:56 -0500
Message-ID: <4D62CC6B.9070408@parallels.com>
Date: Mon, 21 Feb 2011 14:34:51 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Mariusz Kozlowski <mk@lab.zgora.pl>, LKML <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH] Remove obsolete Documentation/00-INDEX entries
References: <4D6095E3.2040103@parallels.com>	<20110221185205.GA23284@mako-laptop>	<4D62C43F.5040302@parallels.com> <20110221120303.48106f6c.rdunlap@xenotime.net>
In-Reply-To: <20110221120303.48106f6c.rdunlap@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.54.86.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 02:03 PM, Randy Dunlap wrote:
>> I have a http://kernel.org/doc/make/doclinkcheck.py which finds the
>> files it lists which don't exist and the files which exist but aren't
>> listed.  The current list of files 00-INDEX says exist, but aren't at
>> that location, is:
> 
> I'll fix some of these (or accept patches to do so).
> Thanks.

Let's see...

From: Rob Landley <rlandley@parallels.com>

Time interpolators were removed in git 1f564ad6d41828
Voyager support went away in git b6b6e2b112caf

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

 Documentation/00-INDEX |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 8dfc670..f607367 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -328,8 +328,6 @@ sysrq.txt
 	- info on the magic SysRq key.
 telephony/
 	- directory with info on telephony (e.g. voice over IP) support.
-time_interpolators.txt
-	- info on time interpolators.
 uml/
 	- directory with information about User Mode Linux.
 unicode.txt
@@ -346,8 +344,6 @@ vm/
 	- directory with info on the Linux vm code.
 volatile-considered-harmful.txt
 	- Why the "volatile" type class should not be used
-voyager.txt
-	- guide to running Linux on the Voyager architecture.
 w1/
 	- directory with documents regarding the 1-wire (w1) subsystem.
 watchdog/
