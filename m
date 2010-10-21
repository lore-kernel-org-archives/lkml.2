Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab0JULfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:35:55 -0400
Received: from fep15.mx.upcmail.net ([62.179.121.35]:36925 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab0JULfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:35:54 -0400
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH 0/7] perf,x86: PEBS/BTS buffer allocation changes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20101019134256.087045503@chello.nl>
References: <20101019134256.087045503@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 13:35:46 +0200
Message-ID: <1287660946.3488.105.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=xhnIrgVimuy9wQ+RkywzulFXCq7zNkI+ObDjxzBho7Y= c=1 sm=0 a=-KpEscm3vOMA:10 a=IkcTkHD0fZMA:10 a=a9Mq2fA7e3t7ShMRO_sA:9 a=xt-F8Rzb9s9E3va_liCS2G8gv-cA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 15:42 +0200, Peter Zijlstra wrote:
> Hi Stephane,
> 
> Your PEBS/BTS buffer patch failed a .config dependent build, which on its own
> was rather easy to fix, but Ingo objected to the size of the patch and asked me
> to rewrite in smaller increments. This patch series is the result.
> 
> What do you think?

Stephane, can I get an ack/review tag for this?

