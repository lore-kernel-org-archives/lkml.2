Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0K3V5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:57:47 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:33923 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0K3V5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:57:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LCzx399sPiVD7CFXkfFY+7TPoImkEN1mXKulz483K66gEPSblATVV8JcYPdR13lpb4
         V3va4jd3CMh+dK2E1bNInl7WIO0ppUzEHYsCerrKMZZPY8GStRBTTDUv9hOsvUSAP28B
         gZ2rMCFIO3LVYFCWLctYuFdDOMTGLZ7YLdjDs=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 0/8] Add yaffs2 file system:  Third patchset
Date: Wed,  1 Dec 2010 10:57:26 +1300
Message-Id: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third submission of a yaffs2 patchset.

I would like to thank everyone that has given comments so far. They
have been most helpful.

I would like to thank CELF and Google for sponsoring the effort to get
yaffs2 mainlined.

This code is patched from 3788df745cd72e035c0c991157cb727a8ecb1f17
at git://www.aleph1.co.uk/yaffs2.

This patch set takes onboard almost all the comments provided since the
last set of patches. Most noteably :
* Removal of kernel locking
* Removal of some debugging  /proc entries
* Use of kernel hweight8/32() functions.

This code ran various tests for the whole night with no problems seen.

Comments/feedback welcome, but I'm hopefully getting pretty close to
acceptance :-).


-- Charles
