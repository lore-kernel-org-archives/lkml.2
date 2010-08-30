Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0H3HGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:06:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44867 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0H3HGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=i0ztfyws6GQkx9g0y9dEgsPnBq5DPiv2t5VjsTMoq0WnWmJxK+mdKo8chiUiibLyBj
         N1+/wuhynD3t0pTTG+JsmNJyfnQuwNmG8QOUj3iI6qphwIKq0CULijhHXyGKGjB52NwR
         EgQjNqFtQ3MYYcW2i0ds2Jz3ovM9vXUOrgasM=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 30 Aug 2010 15:00:17 +0800
Message-ID: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
Subject: Linux Kernel GDB tracepoint module 2010-8-30 release
To: "gdb@sourceware.org" <gdb@sourceware.org>, linux-kernel@vger.kernel.org
Cc: Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>, mqyoung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://kgtp.googlecode.com/files/kgtp_20100830.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20100830
to get it.

Fix bug in ref16, ref32, ref64 in issue
https://code.google.com/p/kgtp/issues/detail?id=2
Fix bug that disable some tracepoint will make "tstart" get error.

Support qtstatus. Then KGTP support GDB command "tstatus".
Add support for "make install" and "make uninstall".
Add support for qtro. Fix a bug about GTP_GDBRSP_REG_SIZE.

Change gtp_list make it more efficient.

Please goto http://code.google.com/p/kgtp/wiki/HOWTO to get more info
about how to use KGTP.
