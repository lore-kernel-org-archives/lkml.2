Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2ARN1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:27:40 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:5380 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2ARN1j convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 18 Jan 2012 08:27:39 -0500
Message-Id: <4F16D6D6020000780006D727@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 13:27:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <acme@ghostprotocols.net>,
        <paulus@samba.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] perf/x86-64: "bench mem" improvements
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the context of building up confidence in the proposed memset() and
to be proposed memcpy() adjustments (to make them support regions
of 4Gb and more), a number of limitations were found in the current
"bench mem" functionality specific to x86-64. Those are being addressed
in this series:

1: make "default" memcpy() selection actually use glibc's implementation
2: also allow measuring alternative memcpy implementations
3: also allow measuring memset()
4: allow passing an iteration count to "bench mem mem{cpy,set}"

Signed-off-by: Jan Beulich <jbeulich@suse.com>

