Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2CWCBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab2CWCBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:01:02 -0400
Date: Thu, 22 Mar 2012 22:00:52 -0400
From: Dave Jones <davej@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: excessive MSR print out during boot.
Message-ID: <20120323020052.GA11519@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During bootup, I now have 162 messages like this..

[    0.227346]  MSR0000001b: 00000000fee00900
[    0.227465]  MSR00000021: 0000000000000001
[    0.227584]  MSR0000002a: 00000000c1c81400

commit 21c3fcf3e39353d4f21d50e257cc74f3204b1988 looks suspect.
It claims that it will only print these out if show_msr= is passed,
but that doesn't seem to be the case.

	Dave

