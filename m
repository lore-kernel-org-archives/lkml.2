Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab1IPH7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 03:59:34 -0400
Received: from lo.gmane.org ([80.91.229.12]:52117 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab1IPH7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 03:59:33 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Subject: Re: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
Date: Fri, 16 Sep 2011 00:59:19 -0700
Message-ID: <j4uvkn$gdj$1@dough.gmane.org>
References: <20110914133034.687048806@chello.nl> <20110914133750.739484417@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 216-239-45-4.google.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
In-Reply-To: <20110914133750.739484417@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's probably worth folding the idle_cpu fix for checking whether 
there's an enqueued task into this.

- Paul

