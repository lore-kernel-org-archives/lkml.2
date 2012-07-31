Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2GaMh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab2GaMh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:37:57 -0400
Message-ID: <5017D19B.5080806@redhat.com>
Date: Tue, 31 Jul 2012 15:37:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Steven Rostedt <srostedt@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Testing tracer wakeup_rt: .. no entries found ..FAILED!
References: <20120724090330.GA9830@localhost> <20120724090720.GA10434@localhost> <1343663105.3847.7.camel@fedora> <20120731121759.GA17822@localhost>
In-Reply-To: <20120731121759.GA17822@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 03:17 PM, Fengguang Wu wrote:
> 
> It's good to quickly get to the root cause :) Can we possibly detect
> whether we are in a virtual machine and hence skip this particular
> test case?

cpu_has(&boot_cpu, X86_FEATURE_HYPERVISOR)

-- 
error compiling committee.c: too many arguments to function


