Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1HCLAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:00:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1HCLAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:00:04 -0400
Subject: Re: [tip:perf/urgent] perf sched: Fix list of events, dropping
 unsupported ':r' modifier
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-9710118bd4e7f3406865171cb9b9c94547c1c2f9@git.kernel.org>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
	 <tip-9710118bd4e7f3406865171cb9b9c94547c1c2f9@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Aug 2011 12:59:21 +0200
Message-ID: <1312369161.1147.292.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 07:25 +0000, tip-bot for Stephane Eranian wrote:
> Looks to me like the :r modifier is not supported anymore, so remove it from
> the list of events. 

acme, why is that anyway? -R is a fun way to save some typing, but not
supporting :r anymore takes away the option of not getting
PERF_SAMPLE_RAW output for every event.
