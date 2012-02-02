Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2BBPxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:53:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35660 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab2BBPxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:53:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAL8zT=gX5=S9fd1MdYyYVYg+35anmK-aJwFj9fUiKNuMSb8n_w@mail.gmail.com>
References: <CAL8zT=gX5=S9fd1MdYyYVYg+35anmK-aJwFj9fUiKNuMSb8n_w@mail.gmail.com>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Thu, 2 Feb 2012 16:52:50 +0100
Message-ID: <CAL8zT=jXmSWbEQO2T2Kpp2_Yei5VJ+sGVt5U2vJwPo=6T2YY1g@mail.gmail.com>
Subject: Specifying some processes to record using perf
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jean-Michel Hautbois <jhautbois@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am using perf and I have several process and threads to record.
I know that some threads in particular are interesting, and I don't
find a way to specify multiple threads in perf record.
The "-t" option takes only one thread IIUC.
I don't know if the "--cgroup" is intended to do that, but I didn't
succeed to use it...

I would also like to exclude one specific process (or thread) when I
do a system-wide record, and I think it is not possible either ?

Thanks in advance !
Regards,
JM
