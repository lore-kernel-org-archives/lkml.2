Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1HHNIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:08:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57790 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab1HHNIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:08:45 -0400
Subject: Re: preempt_disable and softirq
From: Peter Zijlstra <peterz@infradead.org>
To: Venkat Subbiah <v.subbiah@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 08 Aug 2011 15:08:33 +0200
In-Reply-To: <CA+yNG29pbNxiES1kR=sKr3Sn3g8rgz5p17dZq7MBHz1F9hnkCA@mail.gmail.com>
References: <CA+yNG29pbNxiES1kR=sKr3Sn3g8rgz5p17dZq7MBHz1F9hnkCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312808913.10488.32.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 19:03 -0700, Venkat Subbiah wrote:
> Does disabling preemption by calling preempt_disable() cause softirqs
> on the local cpu to be disabled too? 

No.
