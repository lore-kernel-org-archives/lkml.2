Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab2IUJhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:37:43 -0400
Received: from nm32.bullet.mail.ne1.yahoo.com ([98.138.229.25]:21039 "HELO
	nm32.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757111Ab2IUJhm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:37:42 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2012 05:37:41 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 984998.22226.bm@omp1016.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=XWEw97UyI7ul7uP2UyCVGTVGLZJX7SnRLsJWGemr4REtSyTLiOuQ2i6w80gk+h5TjHDwfn/Wa1926R8xNhSJCgmmqvmki1GJL8ypvByAkL7KJvYwpe1tCfCnGBI4n5JkVnjTchs37fKm/PS7rXp5Wlv3cv1ibif4Ikw9hzp1Bfc=;
X-YMail-OSG: 34dUKLsVM1ks2JzfPQn7N4pmJXYdSIwvLaWEf9j6kyK.zOh
 VZ8RzTKAkA1Uk3r22zV6GtXV1th_wK8BMH6BonysdgteFR8cGytghpLQ658S
 EPJdO6pqz0SYmEuHsR_lRiuhOMzUFRfjpNS.rpvhPFIF5eNf5sv4.zjdAOuk
 IiQTxxtmnmUXOpp8AZVAAKXvC92oWuziM50gCRXQcsnGoh0n2FBZA5xj_lQC
 kIxPm_wxPsRGzs0vI0IO8B2eTzFnQqJop5TVwQ2DXWh3.WRyTy5rSbU4ucOU
 JPs_f4kUvhJQiVSm3Fq6ige6Hrxt61xx0LiE24I_OGGSMgVgWaSht59xa8O4
 WMgOPgXEjJIer9c3qT6Z4rWycTMuKkL.bJg9.iG5n0fBO5n7NhQIQerLrcIh
 e0w9sBEZcYG5Imx7K93JOm7blVtVNcbnEt4kxm40h01LO.c7C31Qzf4mW2ng
 9vuKe.VXLmATVdUBG56mRu0cYouZfkvnHNRRXRWm7Su117G9KDe9jbhNXHYl
 Z4PmZD5J.JNL18epaA6bntWbZ3hGsuAw42.vV4CHEK1A-
X-Mailer: YahooMailWebService/0.8.121.416
Message-ID: <1348219885.5550.YahooMailNeo@web120504.mail.ne1.yahoo.com>
Date: Fri, 21 Sep 2012 02:31:25 -0700 (PDT)
From: Eugene Markow <ejmarkow@yahoo.com>
Reply-To: Eugene Markow <ejmarkow@yahoo.com>
Subject: Re: [PATCH] i915: Don't register backlight when max PWM value is unknown
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In reference to:

-----
commit 28dcc2d60cb570d9f549c329b2f51400553412a1
Author: Jani Nikula <jani.nikula@...com>
Date:   Mon Sep 3 16:25:12 2012 +0300


   drm/i915: do not expose a dysfunctional backlight interface to userspace
-----

Using kernel snapshot 3.6.0-rc6 commit 4651afb (Mon, 17 Sep 2012), dmesg is showing:

[5.764086] [drm:intel_panel_setup_backlight] *ERROR* Failed to get maximum backlight value



Regards,

Eugene Markow

