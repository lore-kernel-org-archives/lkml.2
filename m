Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0K2Lyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:54:38 -0500
Received: from canuck.infradead.org ([134.117.69.58]:35887 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab0K2Lyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:54:37 -0500
Subject: Re: [PATCH 3/6] perf: Add timestamp to COMM and MMAP events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1291009409-sup-4332@au1.ibm.com>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
	 <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com>
	 <1290510512.2072.387.camel@laptop>
	 <20101123124121.GA11101@ghostprotocols.net>
	 <20101125154718.GE15875@ghostprotocols.net>
	 <1291009409-sup-4332@au1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 12:54:50 +0100
Message-ID: <1291031690.32004.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 17:06 +1100, Ian Munsie wrote:
> 
> 
> This goes away if PERF_SAMPLE_CPU is added to the mix so that the
> timestamps are offset from the first event of *their* CPU, otherwise
> time-epoch can go negative, as it has done here. 

How does that happen, I though the power7 sched_clock() was fully
synchronized and monotonic across all cores?
