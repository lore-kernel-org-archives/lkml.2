Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2BQPMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:12:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:48442 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2BQPMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:12:36 -0500
Message-ID: <1329491549.2293.275.camel@twins>
Subject: RE: perf, x86: Disable PEBS on SandyBridge chips
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Stephane Eranian <eranian@google.com>
Date: Fri, 17 Feb 2012 16:12:29 +0100
In-Reply-To: <4F3E4A7A.1070708@gmail.com>
References: <4F3E4A7A.1070708@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 13:39 +0100, Maarten Lankhorst wrote:
> Hey Peter,
> 
> Why is PEBS disabled? If I look at the intel_clovertown_quirks I can see 
> why it's disabled for that cpu, but the sandy bridge one lacks any kind 
> of clarification or information on why, or how I can learn more.

hpa, could you get the official Intel answer on this?
