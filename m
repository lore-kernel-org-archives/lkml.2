Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1KHE3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 23:29:50 -0500
Received: from smtp-out.google.com ([74.125.121.67]:10533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1KHE3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 23:29:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:subject:x-system-of-record;
	b=vLAHlHDNVyjrOnvEHtFrGXASB+acnD/4Z0aK1ZLqj38+rmH9jQXgYoYuNhfxrj6oK
	5V0ewx4Sx/oIg7/3FGiiw==
Message-Id: <20111108042632.977080206@google.com>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:26:32 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/3] sched: bandwidth-control tweaks for v3.2
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find attached a few minor tweaks for bandwidth control that are worth
considering for 3.2

The first two are a performance improvement for the !enabled case and a buglet
fix.  While the last makes idle_balance() work with throttling.

Thanks,

- Paul




