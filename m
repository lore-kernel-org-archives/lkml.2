Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab2EPCiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:38:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52311 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758865Ab2EPCiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:38:09 -0400
Message-ID: <4FB3130D.7040308@gmail.com>
Date: Tue, 15 May 2012 20:38:05 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, acme@redhat.com
Subject: Re: [PATCH v2 0/5] perf tools: add meta-data header support in pipe
 mode
References: <1337081295-10303-1-git-send-email-eranian@google.com> <87ehqkewom.fsf@sejong.aot.lge.com> <4FB30B52.7080104@gmail.com> <87txzgdfeo.fsf@sejong.aot.lge.com>
In-Reply-To: <87txzgdfeo.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See tools/perf/util/header.{ch}
Runtime example:

perf script -i /tmp/perf.data -I

# ========
# captured on: Tue May 15 20:22:15 2012
# ========
#
# hostname : nxos-vdc-dev3
# os release : 3.4.0-rc7+
# perf version : 3.4.rc4.137.g978da3.dirty
# arch : x86_64
# nrcpus online : 16
# nrcpus avail : 16
# cpudesc : Intel(R) Xeon(R) CPU E5540 @ 2.53GHz
# cpuid : GenuineIntel,6,26,5
# total memory : 24680324 kB
# cmdline : /tmp/pbuild/perf record -fo /tmp/perf.data -- /tmp/noploop

...

'perf report --stdio' also shows it. It gets lost in the TUI.

David
