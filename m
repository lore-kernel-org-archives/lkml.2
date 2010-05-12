Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0ELTaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:30:23 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52400 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab0ELTaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:30:21 -0400
Date: Thu, 13 May 2010 01:00:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: menage@google.com, peterz@infradead.org, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100512193012.GO3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1273669541.3086.24.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1273669541.3086.24.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dhaval Giani <dhaval.giani@gmail.com> [2010-05-12 15:05:41]:

> Hi folks,
> 
> This does not break ABI since applications which were explicitly setting
> up the cpusets will still be setting them up anyway. And if someone was
> checking if a cpuset was setup or not by checking the state of
> cpuset.cpus_allowed, then it was broken and should be fixed.
>

The only ABI breakage I would consider is

A user space application reading those values and expecting them to
be empty before taking any action

-- 
	Three Cheers,
	Balbir
