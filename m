Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2J3IOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:14:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:52194 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2J3IOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:14:43 -0400
Message-ID: <1351584858.4047.32.camel@twins>
Subject: Re: [PATCH V2 RFC 3/3] kvm: Check system load and handle different
 commit cases accordingly
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Date: Tue, 30 Oct 2012 09:14:18 +0100
In-Reply-To: <508F6C60.1050202@linux.vnet.ibm.com>
References: <20121029140621.15448.92083.sendpatchset@codeblue>
	 <20121029140717.15448.83182.sendpatchset@codeblue>
	 <1351533280.24721.46.camel@twins> <508F6C60.1050202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 11:27 +0530, Raghavendra K T wrote:
> Okay, now IIUC, usage of *any* global measure is bad?

Yep, people like to carve up their machines, esp. now that they're
somewhat bigger than they used to be. This can result in very asymmetric
loads, no global measure can ever deal with that.


