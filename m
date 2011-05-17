Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1EQPqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:46:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:38545 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab1EQPqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:46:19 -0400
Subject: Re: [PATCH] perf: make annotate more readable
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu
In-Reply-To: <20110517153207.GA9834@quad>
References: <20110517153207.GA9834@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 May 2011 17:46:03 +0200
Message-ID: <1305647163.2466.5917.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 17:32 +0200, Stephane Eranian wrote:
> This patch adds two new options to perf annotate:
> 	- -R, --no-asm-raw : do not display raw instruction encodings
> 	- -S, --no-source  : do not interleave source code with assembly code
> 
> We believe those options make the output of annotate more readable.
> Systematically displaying source can make it hard to follow code and
> especially optimized code.

Agreed, asm->C maps from optimized code are a mess.

> Raw encodings are not useful in most cases.

Also true.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
