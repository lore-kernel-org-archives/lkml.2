Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab1CCWFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:05:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50256 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1CCWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:05:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lWCrXWJMMLZ9n2RkJcoPDLYjfmMUhWw6mZ7qw1JeLGwg8B4AdyCZs1Ml5UA1oK1XRz
         xsCzKR36P4CE2esgTi0L2IcT8yHVATijK7fJWe0Do90dbujLdDhrDhNKm9DDtXTiKTcP
         mw0oLtp28vfhgxf0wmsk8t9AKchvwjSlzdP6Q=
Message-ID: <4D70108F.7040808@gmail.com>
Date: Fri, 04 Mar 2011 01:05:03 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, brgerst@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Clean up initmem_init
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org> <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com> <20110221083511.GC31267@htj.dyndns.org> <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com> <4D700B93.2080807@gmail.com> <alpine.DEB.2.00.1103031359070.4141@chino.kir.corp.google.com> <4D701015.2040703@kernel.org>
In-Reply-To: <4D701015.2040703@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 01:03 AM, Yinghai Lu wrote:
> On 03/03/2011 02:00 PM, David Rientjes wrote:
> 
> he want
> 

yeah, if only i didn't miss something

-- 
    Cyrill
