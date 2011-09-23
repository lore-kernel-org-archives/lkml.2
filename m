Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1IWN7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 09:59:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35553 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1IWN7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 09:59:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=u6tohO1Cj5g+XkegnNQ3S70D2G5B2yP6AbIhvHBiuMa/dBpZFyBeP4kIWSq+YDRW2
	hrCncWtjl20otDOPHAAoQ==
MIME-Version: 1.0
Date: Fri, 23 Sep 2011 15:59:33 +0200
Message-ID: <CABPqkBR5ie5yJAB1xTCfQoZroFZWna42=iptmB_Cwt3hCuyQ=w@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf symbols: /proc/kallsyms does not sort module symbols
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, anton@samba.org,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        ak@linux.intel.com, Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What's the status of this patch?

It is not in 3.1.0-rc7. It is needed!

I ran into serious issues (bogus symbols) with a profile where
kernel modules were stressed and it boiled down to kallsyms__parse()
being broken because /proc/kallsyms is assumed sorted when it actually
is NOT.
