Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619Ab1F1SNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:13:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63863 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760578Ab1F1SMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 14:12:00 -0400
MIME-Version: 1.0
Date: Tue, 28 Jun 2011 14:11:59 -0400
Message-ID: <BANLkTin_Yo+wnwWyMFoG3Nv5SSzJj8J1_w@mail.gmail.com>
Subject: Question on syslogd and syslog
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        linux-newbie@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

    I am looking to modify number of facilities available in syslog so
that for my application I can have much more array of them at disposal
of my need. So currently only LOG_LOCAL0 - LOG_LOCAL7 are defined for
user, what if I want to extend them, is there a way I can extend them.
Or should I go ahead and modify the source code of syslog. Can any
please point me in right direction and where can I get syslogd and
syslog source code. Thanks in advance.

-- 
Regards,
Sri.
