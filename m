Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1DVVwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:52:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:33015 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab1DVVwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:52:16 -0400
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1303508226.4865.8.camel@laptop>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
	 <1303407662-15564-2-git-send-email-acme@infradead.org>
	 <20110422063429.GA16643@elte.hu>  <20110422080604.GA22611@elte.hu>
	 <1303508226.4865.8.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 23:54:53 +0200
Message-ID: <1303509293.4865.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 23:37 +0200, Peter Zijlstra wrote:
> The below needs filling out for !x86 (which I filled out with
> unsupported events) and x86 needs the offcore bits fixed to auto select
> between the two offcore events.

Urgh, so SNB has different MSR_OFFCORE_RESPONSE bits and needs another table.

