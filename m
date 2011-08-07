Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1HGQWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 12:22:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40396 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1HGQWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 12:22:52 -0400
MIME-Version: 1.0
Date: Sun, 7 Aug 2011 11:22:51 -0500
Message-ID: <CAH2r5mszsiu2Gm-DPbfT8UReT=eBTf4Du4eyEapG8Ayn7UN1pw@mail.gmail.com>
Subject: new sparse warning fs/cifs/cifsfs.c:168:15: warning: dereference of
 noderef expression fs/cifs/cifsfs.c:542:15: warning: dereference of noderef expression
From: Steve French <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed a series of sparse warnings (on all calls to cifs's GetXid
after building on a newly install fc15 system (yum installed a sparse
binary dated June 23).

fs/cifs/cifsfs.c:168:15: warning: dereference of noderef expression
fs/cifs/cifsfs.c:542:15: warning: dereference of noderef expression

Has sparse changed to add a new warning - I see (from quick search)
others getting this on other modules years ago, but I didn't see
anything obvious wrong with the definition of the function, and I
hadn't noticed sparse complaining about it before, and would like to
remove the 50+ new messages as they clutter the build output.
-- 
Thanks,

Steve
