Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab1KENiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 09:38:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54926 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1KENiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 09:38:20 -0400
Message-ID: <4EB53C46.1060301@gmail.com>
Date: Sat, 05 Nov 2011 14:38:14 +0100
From: Carla Sella <carla.sella@gmail.com>
Reply-To: carla.sella@gmail.com
Organization: Carla Sella
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: suspend/resume does not work on G62 notebook PC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I need to report a bug on  suspend/resume that's not working on my HP
G62 notebook PC.
I've been having this problem since testing Ubuntu Natty Beta 1 iso and
I'm still having it with Ubuntu Oneiric.
My laptop is a HP  model G62.

During the "Extended Suspend/Resume test"
(http://testcases.qa.ubuntu.com/System/SuspendResume), all tests run
with "sudo /usr/share/checkbox/scripts/suspend_test --full" fail with 
message: "SUSPEND FAILED, did not go to sleep".
Also Hibernate/Resume smoke test does not work, the screen goes black
for a few seconds, more or less 15 and then password is required and you
go back to the users session.
This is the bug opened on launchpad with all the details:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/752881



-- 
Carla Sella
email: carla.sella@gmail.com
https://launchpad.net/~carla-sella

