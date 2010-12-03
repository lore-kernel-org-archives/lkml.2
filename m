Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab0LCMRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:17:52 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47472 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577Ab0LCMRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:17:50 -0500
Date: Fri, 3 Dec 2010 17:47:46 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/3] kvm: keep track of which task is running a KVM
 vcpu
Message-ID: <20101203121746.GE27994@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101202144324.4a79263b@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202144324.4a79263b@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 02:43:24PM -0500, Rik van Riel wrote:
>  	mutex_lock(&vcpu->mutex);
> +	vcpu->task = current;

Shouldn't we grab reference to current task_struct before storing a pointer to 
it?

- vatsa
