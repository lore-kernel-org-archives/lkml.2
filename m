Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab0D3RF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:05:27 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17894 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab0D3RFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:05:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=TylHQ9lc8tmgJvP+EhLYHx0uvhRS5eoJ+NFgqVc9+nj8M+zf5ymLxAx9Q+PY4OdBr
	v/J3JCoJa+yzZ1RE6AtTg==
MIME-Version: 1.0
Date: Thu, 29 Apr 2010 14:28:02 +0200
Message-ID: <v2mbd4cb8901004290528jb13ced31j7f8b0231019bbbcb@mail.gmail.com>
Subject: [BUG] perf: perf trace does not work anymore
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to use perf trace to dump the raw samples.

$ perf record -R noploop 5
noploop for 5 seconds
[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 0.269 MB perf.data (~11759 samples) ]

$ perf trace
  Fatal: reading input file (size expected=3 received=-1)

Seems like trace does not understand the format of the perf.data file anymore.
This used to work. Did you change the purpose of perf trace?
