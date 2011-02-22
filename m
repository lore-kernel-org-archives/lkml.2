Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1BVKSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:18:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57701 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab1BVKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TVl4KFg/HW+/WiuO1ewi7dwe5jZbwl5K0U1QRZqsM0hO9Ci77ysU1YSGDRZvLB4qs8
         FCBHD+rBRwXPTXbneqjvYd0ESh937kQ6W44Dm54jXOlbIDhFIUrgR/UiLb2SWix16/e6
         6hQdERiYDsUXUnMXctPsGcmoy3rDP7BSYR/sA=
Date: Tue, 22 Feb 2011 11:14:01 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH UPDATED 2/3 tip:x86/mm] x86-64, NUMA: Move NUMA
 emulation into numa_emulation.c
Message-ID: <20110222101401.GV31267@htj.dyndns.org>
References: <20110218135836.GG21209@htj.dyndns.org>
 <20110218135939.GH21209@htj.dyndns.org>
 <20110221082657.GA31267@htj.dyndns.org>
 <4D629C98.4030501@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D629C98.4030501@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 09:10:48AM -0800, Yinghai Lu wrote:
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks.  Patches 1-3 applied to x86-numa.

-- 
tejun
