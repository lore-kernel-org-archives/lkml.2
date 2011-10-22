Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1JVQaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 12:30:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:42467 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab1JVQaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 12:30:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mantas M." <grawity@gmail.com>
Subject: Re: [PATCH] jme: fix irq storm after suspend/resume
Date: Sat, 22 Oct 2011 19:27:09 +0300
Message-ID: <j7uqst$kpc$1@dough.gmane.org>
References: <20111022125620.GA2256@ecki.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 78-60-211-195.static.zebra.lt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111005 Thunderbird/8.0
In-Reply-To: <20111022125620.GA2256@ecki.lan>
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/11 15:56, Clemens Buchacher wrote:
> If the device is down during suspend/resume, interrupts are enabled
> without a registered interrupt handler, causing a storm of
> unhandled interrupts until the IRQ is disabled because "nobody
> cared".
>
> Instead, check that the device is up before touching it in the
> suspend/resume code.
>
> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=39112

Just tested the patch, suspend/resume works well.

-- 
Mantas M.

