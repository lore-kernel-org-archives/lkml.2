Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1DIHjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 03:39:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61167 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1DIHjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 03:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dmqxik0wr64IrkOMUqm0FXVIAJht5uKcqtG1pJNdFEIcQwGzD0P1E2Ew4OVqZHiyDN
         H+bxOfUbbj6bTd2pd1iIYyCsJaj1xqPXaB8acBCNN/n6rtnA+DCoWENzLRL4djjsGq/x
         z7zdKgYr/cOtF/AEVvN1f3bnySrJ5EUxIsJ24=
MIME-Version: 1.0
Date: Sat, 9 Apr 2011 17:39:42 +1000
Message-ID: <BANLkTimoDVMcvFdoUedyfw4Thv8=DsV-5A@mail.gmail.com>
Subject: iwlegacy Kconfig mess
From: Dave Airlie <airlied@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, wey-yi.w.guy@intel.com,
        linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just did an make from my old config and noticed my wireless got
lost, but then I went looking for it and saw the Kconfig for iwlegacy.

Why is IWLWIFI_LEGACY a selectable config which the drivers depend on?
it also has no help text. Surely it would make more sense for the two
drivers to select it and have it not appear at all.

Dave.
