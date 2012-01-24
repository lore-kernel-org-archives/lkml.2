Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2AXMvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:51:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab2AXMvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:51:18 -0500
Message-ID: <4F1EA940.4040701@redhat.com>
Date: Tue, 24 Jan 2012 14:51:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EEC5.8050807@linux.vnet.ibm.com> <CAJSP0QVxR9sYYh_Vr6ZKAU-YrWpjgL5jpiKz2zt7eJxV_kgaOg@mail.gmail.com> <20120117115913.GC17420@amt.cnet>
In-Reply-To: <20120117115913.GC17420@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 01:59 PM, Marcelo Tosatti wrote:
> > 
> > All this copy-paste could be avoided by sharing this stuff with the
> > arch/x86/kvm/ code.
>
> Yes, same for KVM_MAX_VCPUS.
>
>

This is an internal define.  perf kvm should work with different kernel
versions, so it needs to query the value dynamically.

-- 
error compiling committee.c: too many arguments to function

