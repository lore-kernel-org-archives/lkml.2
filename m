Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1AKDsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:48:36 -0500
Received: from smtp-out.google.com ([74.125.121.67]:5242 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab1AKDsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:48:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HmghWhYaz64i+mld5ekw2YHfcSM7ebpmp+Na/bN2Bb93XicVC5ksFZu5Rl0/8gi2rQ
         QNMQsRwjinLCzcYRmiRQ==
Date: Mon, 10 Jan 2011 19:48:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Subject: Re: [PATCH 01/16] x86: Kill unused static boot_cpu_logical_apicid
 in smpboot.c
In-Reply-To: <1293731369-10851-2-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1101101930290.31039@chino.kir.corp.google.com>
References: <1293731369-10851-1-git-send-email-tj@kernel.org> <1293731369-10851-2-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Tejun Heo wrote:

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
