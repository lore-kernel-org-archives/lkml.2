Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1CVSDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:03:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35785 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1CVSDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:03:41 -0400
MIME-Version: 1.0
X-Originating-IP: [172.22.72.22]
Date: Tue, 22 Mar 2011 11:03:40 -0700
Message-ID: <AANLkTimfNwZxzAmerLtCX9eS_YD5DtAUngXkD=XHYZ=g@mail.gmail.com>
Subject: [ANNOUNCE] Upstart 1.2 released
From: Scott James Remnant <scott@netsplit.com>
To: Upstart Dev List <upstart-devel@lists.ubuntu.com>,
        upstart-devel@upstart.at, upstart-release@upstart.at
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brown paper bag release to fix an important bug in 1.1 that broke
people with pdksh as /bin/sh


1.2  2011-03-22  "This sort of thing is my bag, baby"

        * Fixed incorrect shell redirection syntax that broke at least
          pdksh.  (Bug: #739984)


The tarball can be found here:

      http://upstart.at/download/1.x

For more information on upstart:

      http://upstart.at/


Scott
