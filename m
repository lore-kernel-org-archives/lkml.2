Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0HXFvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:51:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54653 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab0HXFvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xVWZUwzxtMITSP4vRjjFIQSjLfInJ/MWXEyjy3JTOkq+HVpbKqkSWDFpqDSnnCW0RT
         9GAVXxrOzJhTQHR3ZePhr02BRAd8iseHHyFT7zk2cTqf2bCMoh+AA6y3uriPA3Ygp7am
         1dfAZtlfPlbmcN9/qllNJB3MvrwA0c8R0Z+/I=
Message-ID: <4C735DC7.7090308@gmail.com>
Date: Tue, 24 Aug 2010 07:51:03 +0200
From: Roberto Oppedisano <roberto.oppedisano@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100819 Thunderbird/3.1.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: regression: ecryptfs broken on 2.6.36-rc2 (x86_64)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I'm having the very same problem reported from another ecryptfs user.

https://bugs.launchpad.net/ecryptfs/+bug/623087

In short permissions seem to be broken on ecryptfs mounts, and ls output 
looks like:

ls: cannot access enctest/file1: No such file or directory
ls: cannot access enctest/sub: No such file or directory
total 12
545077 -????????? ? ? ? ? ? file1
545075 -rw-r--r-- 1 root root 3 2010-08-24 08:53 file3-2.6.36
545078 d????????? ? ? ? ? ? sub

Everything was fine in 2.6.35.



