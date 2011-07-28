Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1G1Mxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:53:39 -0400
Received: from web137313.mail.in.yahoo.com ([121.101.151.140]:45149 "HELO
	web137313.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751620Ab1G1Mxh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:53:37 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 08:53:36 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5zZOZOuzjyI8E3Avm8NXkKUaBnKy6xK8Rh5Gj+qa1VfPh1YSOrBnh9Ebwjdgo0pO6WQgPOZycMFFkC7L2a6p4CnMgukWoA6JUyYcJPmTwK/N++c/1itclU/f8hvHUEf9lPY6FzqHripBmPSM2ZBaO8nA+f0gVQDuzatW1gLtYS8=;
X-YMail-OSG: 7vmPRMQVM1lq.g2UJDReXMjZY4qF0wr_ebKm4HdNfte7COg
 3GV.soirEZj9Eb5xtC_bIH1dHVly1frcNpEgOLyEEIlSNDPy1bjor4KJDPPT
 QJQa.NEPSVUH3AavwkiAaIt4NH1XWxlMF0B9lxZq42j3BhTPR9iOFA6LL3_6
 ypsD3aPU0e5_OOeCIgkNv33uKmrN2BAmzOjH.2ZzjY87ZulmLsdte75Jn1Zb
 Nk3QfSPP4EB2HmspQ9X3a1yljmgmu7yjS0ZzyL2go1JnvXC..ZSzg8tg.Tau
 yaFlAI9562qD826DGzrQVSRqxjfgDYxxLLhv90UOyunUw4AOVAwkwJM_cBRF
 fhXM9F0gQbgws7g1a_DEhZEGbyALs6csCmDouonRZVWAQDz4-
X-Mailer: YahooMailWebService/0.8.112.310352
References: <1311857035.41442.YahooMailNeo@web137319.mail.in.yahoo.com>
Message-ID: <1311857213.26660.YahooMailNeo@web137313.mail.in.yahoo.com>
Date: Thu, 28 Jul 2011 18:16:53 +0530 (IST)
From: Srinivas Nayak <sinu_nayak2001@yahoo.co.in>
Reply-To: Srinivas Nayak <sinu_nayak2001@yahoo.co.in>
Subject: Linux child process does not core dump 
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1311857035.41442.YahooMailNeo@web137319.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In my program, I fork() to get a child process.
Because of some problem, child process terminates by a segmentation fault.
Parent process is still running.

I have compiled my code with -g option.
I have done: ulimit -c unlimited.

I am not getting core dump of the child process.

How can I get the core dump of child process?

Sincerely,
Srinivas Nayak 
________________________________

