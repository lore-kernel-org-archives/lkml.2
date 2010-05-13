Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0EMONn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:13:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63151 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab0EMONl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=ooGPjyPStMmP1hgWJqqM8x/2T3AHVheNnIQrUlPaxH9L5ZPdjzYqMgj7gyz4TNodjd
         fubMJVL3W3y6FxEPY1L6CYpJeJ7LV2Uyg6pqCzYLa91Uce7aJDlhP7zBpW7eRswiV1yG
         eRT7xgNT+TtjPBKqbzSLZu9nPRoTevOWAuVUY=
MIME-Version: 1.0
Date: Thu, 13 May 2010 16:13:41 +0200
X-Google-Sender-Auth: h5P6auUJaNz7Iz6jhiKwI_-4JIo
Message-ID: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
Subject: perf: relative path to source for perf probe?
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to play with perf probe to insert trace events into a
running kernel, but I haven't found a way to specify relative
pathnames. For example, our build machines for Ubuntu build the kernel
inside /build/buildd/linux-2.6.34. If I want to use perf probe, it
seems I need to ensure the source exists in exactly the same location
on my machine.

Compare this to gdb, where I can put the source at
/home/cndougla/perf/build/buildd/linux-2.6.34 and specify a relative
path for sources of /home/cndougla/perf using the dir command. I have
read the perf code and I have not found any way to do this. I would be
interested in adding support for this as a cmd line option, but I'm
not very familiar with the rest of perf. Is this functionality
specific to perf-probe? Should this be in some logic in util/ or in
builtin-probe.c?

Thanks,

-- Chase
