Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2DPJWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:22:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40229 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2DPJWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:22:44 -0400
Date: Mon, 16 Apr 2012 11:22:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 2/2] tools perf: Add a new benchmark tool for
 semaphore/mutex
Message-ID: <20120416092238.GA27526@gmail.com>
References: <491D6B4EAD0A714894D8AD22F4BDE043B158D5@SCYBEXDAG03.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE043B158D5@SCYBEXDAG03.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chen, Dennis (SRDC SW) <Dennis1.Chen@amd.com> wrote:

> A new performance benchmark tool for semaphore or mutex lock.

it would be very useful to paste the output of the tool into the 
changelog, to explain why we want it, to explain how it should 
be used - in addition to explaining (on a high level) how it's 
implemented, what its assumptions are, etc. etc.

A oneliner changelog is really not adequate.

Thanks,

	Ingo
