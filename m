Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2FSSM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:12:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49016 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2FSSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:12:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120619060945.GA8724@shangw>
References: <1339623535.3321.4.camel@lappy>
	<20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
	<1339667440.3321.7.camel@lappy>
	<20120618223203.GE32733@google.com>
	<1340059850.3416.3.camel@lappy>
	<20120619041154.GA28651@shangw>
	<CAE9FiQVitg0ODjph96LnPD6pnWSSN8QkFngEwbUX9-nT-sdy+g@mail.gmail.com>
	<20120619060945.GA8724@shangw>
Date: Tue, 19 Jun 2012 11:12:21 -0700
X-Google-Sender-Auth: 7tM9seTDtMlkDqQgB_D-LbhOSP0
Message-ID: <CAE9FiQXgkV0Fhg_dRNL95xQfXVLUG+h07xxmdX3dCQ0szaty6g@mail.gmail.com>
Subject: Re: Early boot panic on machine with lots of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:09 PM, Gavin Shan <shangw@linux.vnet.ibm.com> wrote:
> Yinghai, it's possible the memory block returned to bootmem and get used/corrupted
> by other CPU cores?

At that point only BSP is running.  and all APs are not started yet.

Yinghai
