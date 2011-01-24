Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1AXKQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:16:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:58097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1AXKQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:16:44 -0500
Subject: Re: [patch 0/5] scheduler fixlets
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110122044458.058531078@google.com>
References: <20110122044458.058531078@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 11:17:26 +0100
Message-ID: <1295864246.28776.320.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 20:44 -0800, Paul Turner wrote:
> A small set of scheduler patches for the CFS side of things.
> 
> Mostly buglet fixes with one or two associated clean-ups.  Each patch should
> be (modulo any merge fuzz) independent.

Thanks Paul, these all look good, applied!
