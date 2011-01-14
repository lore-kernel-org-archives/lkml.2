Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1ANDHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:07:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36959 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1ANDHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:07:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vIicF+NRFyRret5O/WTXco/Gj/qYbL0dpbRZxTtI9kdRv6M1hxh7anuCKJPWE62G2b
         XE5t7uC1F7lSl14pLMpM2wt+kjTo5bYrveo/iTAAf4F5zu4LTCnQ5cmR0WdxFC9aN5ov
         m0Z9EU3UlkPm0hDpBpmleba9q+JhRGG+6RAlY=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 0/10] Add yaffs2 file system:  Fourth patchset
Date: Fri, 14 Jan 2011 16:05:59 +1300
Message-Id: <1294974369-31647-1-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth submission of a yaffs2 patchset.

I would like to thank everyone that has given comments so far. They
have been most helpful.

I would like to thank CELF (now part of Linux Foundation) and Google
for sponsoring the effort to get yaffs2 mainlined.

This code is patched from 371b2eaad7d9c4947ec1e5c5f0576b7e118df617
at git://www.aleph1.co.uk/yaffs2.

This patch set takes onboard almost all the comments provided since the
last set of patches. Most noteably :
* Removal of almost all the wrapper macros. Pretty much all that remains
is some wrapping (YCHAR --> char) to allow Unicode compilation.
* Huge amount of reformating. Code passes checkpatch.pl except for what
* appears to be a checkpatch.pl bug (reported).
* Fixes since last submission.

This code ran various tests for the whole night with no problems seen.

Comments/feedback welcome, but I'm hopefully getting pretty close to
acceptance :-).

-- Charles
