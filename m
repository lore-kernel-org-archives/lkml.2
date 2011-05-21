Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1EUIWK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:22:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57970 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab1EUIWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=h5+FM61HaY2Wf0e14UhXVQ2UDKSbDQd8ZwvgBwfHwRFC8Ummt57hGJptNBzNIya0uD
         OTIYH0PBmNnczJQq79roDSsZJH2UMPSOAasvmFDYXXJ1AJy71FT3C8QAYMToDsp4IDFA
         DuMQlCnEtKBd4VSlw8r6ep/Ifr9P2z9cuWNis=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Subject: [PATCH 0/3] fixes, improvements on scripts/export_report.pl
Date: Sat, 21 May 2011 02:21:45 -0600
Message-Id: <1305966108-13399-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/3] do collectcfiles work in perl itself, eschew shell pipeline
[PATCH 2/3] sort SECTION 2 output of scripts/export_report.pl
[PATCH 3/3] in scripts/export_report.pl use warn() to issue WARNING, so they go to stderr.

also available at git://github.com/jimc/linux-2.6.git export-report branch
