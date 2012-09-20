Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2ITOA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:00:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2ITOAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:00:25 -0400
Subject: Re: [PATCH 0/4] perf header: Save and reuse feature information in
 header (v3)
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <505B1DB5.1030304@gmail.com>
References: <1348119407-12528-1-git-send-email-namhyung@kernel.org>
	 <505B1DB5.1030304@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Sep 2012 22:55:14 +0900
Message-ID: <1348149314.1510.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

2012-09-20 (목), 07:44 -0600, David Ahern:
> On 9/19/12 11:36 PM, Namhyung Kim wrote:
> > Currently the perf header information is used only at initial setup
> > time and discarded.  If it's saved we could reuse the information for
> > various purpose in the future.
> 
> When this gets settled can you update builtin-kvm too? The kvm-events 
> patch too adds a perf_file_section__read_feature() function for 
> extracting cpuid from the header.

Will look at it too.

Thanks,
Namhyung


