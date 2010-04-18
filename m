Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0DRHGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 03:06:40 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:40690 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab0DRHGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 03:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oFlVGveLv3lL6ROn1ey9z0WcWLdZ4VwWILOoot7q57nzebchfJiubeWuGmLfnOkJau
         IcsWWcUVdAaLuHNAPSKB40own6WvJFwMcMqw/l2xjdfrFdRlsTosSaxnlPbzzczPlGKY
         yRSex5C4K6yX81N2H/y5nsxWDvA2qY5nmXCU4=
MIME-Version: 1.0
Date: Sun, 18 Apr 2010 12:36:38 +0530
Message-ID: <x2hcfeab66d1004180006ob6ebdba5r489f58f4edafc1a@mail.gmail.com>
Subject: open sockets from task_struct
From: ratheesh k <ratheesh.ksz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have task_struct structure , how to find all the opened files ? how
to find opened sockets ?

Thanks,
Ratheesh
