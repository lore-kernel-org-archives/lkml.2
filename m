Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1AZQwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:52:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:58350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1AZQwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:52:38 -0500
Subject: Re: [PATCH 16/16] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296060386.28776.1312.camel@laptop>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-17-git-send-email-glommer@redhat.com>
	 <1295893920.28776.468.camel@laptop>
	 <1295895083.15920.9.camel@mothafucka.localdomain>
	 <1295898690.28776.472.camel@laptop>
	 <1295985756.15920.33.camel@mothafucka.localdomain>
	 <1295986386.28776.1101.camel@laptop>
	 <1295988455.15920.35.camel@mothafucka.localdomain>
	 <1295989664.28776.1124.camel@laptop>
	 <1295990853.15920.37.camel@mothafucka.localdomain>
	 <1296035871.28776.1132.camel@laptop>
	 <1296056617.3591.26.camel@mothafucka.localdomain>
	 <1296060386.28776.1312.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 17:53:22 +0100
Message-ID: <1296060802.28776.1321.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 17:46 +0100, Peter Zijlstra wrote:
> it uses a per-cpu virt_steal_time() clock which is
> expected to return steal-time in ns. 

This clock should return u64 and wrap on u64 and be provided when
CONFIG_SCHED_PARAVIRT.
