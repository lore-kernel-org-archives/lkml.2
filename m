Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab2ECV5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:57:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54640 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858Ab2ECV5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:57:51 -0400
Date: Thu, 3 May 2012 14:57:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Arnaud Lacombe <lacombar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: perf build failure on Linus's tree
Message-ID: <20120503215748.GA18995@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus's tree right now (3.4.rc5.67.gac001.dirty) gives me the following
build error when I try to build perf:
    CC util/parse-events-flex.o
<stdout>: In function ‘yy_get_next_buffer’:
<stdout>:1510:3: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
util/parse-events.l: In function ‘parse_events_lex’:
util/parse-events.l:122:1: error: ignoring return value of ‘fwrite’, declared with attribute warn_unused_result [-Werror=unused-result]
cc1: all warnings being treated as errors

Do you really want to ensure that flex's build warnings fail the build?

thanks,

greg k-h
