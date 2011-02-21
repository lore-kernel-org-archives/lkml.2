Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1BUNoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:44:16 -0500
Received: from www.tglx.de ([62.245.132.106]:54066 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019Ab1BUNoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:44:15 -0500
Date: Mon, 21 Feb 2011 14:43:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Make nr_irqs runtime expandable
In-Reply-To: <alpine.LFD.2.00.1102211435320.2701@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1102211442330.2701@localhost6.localdomain6>
References: <tip-e7bcecb7b1d29b9ad5af939149a945658620ca8f@git.kernel.org> <4D6014F9.8040605@kernel.org> <alpine.LFD.2.00.1102211435320.2701@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Thomas Gleixner wrote:
> On Sat, 19 Feb 2011, Yinghai Lu wrote:
> > -	if (start >= nr_irqs) {
> > +	if (start + cnt > nr_irqs) {
> 
> One off. That needs to be  >= nr_irqs. Good catch otherwise.

Confused myself. Check is correct as is.
