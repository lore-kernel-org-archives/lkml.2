Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2FLSgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:36:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44307 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab2FLSgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:36:02 -0400
Message-ID: <4FD78BE6.4060207@zytor.com>
Date: Tue, 12 Jun 2012 11:35:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, andi@firstfloor.org,
        mingo@elte.hu, ming.m.lin@intel.com, Borislav Petkov <bp@amd64.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
References: <20120607071531.GA4849@quad>
In-Reply-To: <20120607071531.GA4849@quad>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi just alerted me to this thread.

I, Thomas and Borislav discussed this at LCE last year, and it really
comes up that we have a *large* number of reasons to load microcode
early.  We then need to keep the microcode around so that it can be
loaded on APs, hotplug CPUs, and after S3 resume.

The protocol discussion happened in this thread:

http://marc.info/?i=1332512984-79664-1-git-send-email-trenn@suse.de

Fenghua Yu at Intel is currently working on the implementation.

	-hpa
