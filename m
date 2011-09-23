Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab1IWGky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:40:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53224 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1IWGkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110922123128.GA9761@quad>
References: <20110922123128.GA9761@quad>
Date: Fri, 23 Sep 2011 09:40:52 +0300
X-Google-Sender-Auth: ft2aDNgdSbeh39rzgGL0GJ2xCrc
Message-ID: <CAOJsxLFDaYxevsH8UYEeZJrz7HCZSg89_XTaXP=hPTTG2HH9=w@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, robert.richter@amd.com,
        ak@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 3:31 PM, Stephane Eranian <eranian@google.com> wrote:
> # CPU0 sibling cores  : 0-3
> # CPU0 sibling threads: 0
> # CPU1 sibling cores  : 0-3
> # CPU1 sibling threads: 1
> # CPU2 sibling cores  : 0-3
> # CPU2 sibling threads: 2
> # CPU3 sibling cores  : 0-3
> # CPU3 sibling threads: 3
> # total memory: 8093212 kB
> # cpuid : GenuineIntel,6,15,11

So how important is this information? The output is going to be somewhat
awkward for very large CPU counts... :-)
