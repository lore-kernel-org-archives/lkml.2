Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab0HJDcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 23:32:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34628 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab0HJDci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 23:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DWNsDdn29yOHDOZKaM9xZI2aUZ4h5hoMtkvN7D8VIZbWMz2/i2jDWPC27jqzYRFLTm
         FOFgg9koYZlTF97W1epmRWO8Tu0wXZJJqpkoQMa79dH5wK9KYmJjF9g7kr13FsVtgeoz
         mMzAaBgt6EBlzTgdx9B+dK/7Aqs5CVnvErlno=
Subject: RE: find_task_by_pid() problem
From: Namhyung Kim <namhyung@gmail.com>
To: Pistis Valentino <vale.pistis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 12:32:32 +0900
Message-ID: <1281411152.1670.24.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm using the routine find_task_by_vpid () linux / sched.h (the oldest
> find_task_by_pid() don't exist), but when I try to compile the file I
> hello_world.c returns an error:

You can only use kernel's EXPORTed symbol, ie. EXPORT_SYMBOL*(), when you
write a module program because kernel links it on its own way.
Try this instead.

pid_task(find_vpid(...), PIDTYPE_PID)

-- 
Regards,
Namhyung Kim


