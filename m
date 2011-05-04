Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1EDXnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:43:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755830Ab1EDXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:43:19 -0400
Date: Wed, 4 May 2011 16:42:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>, John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] comm: ext4: Protect task->comm access by using
 get_task_comm()
Message-Id: <20110504164257.5bb61879.akpm@linux-foundation.org>
In-Reply-To: <20110504163657.52dca3fc.akpm@linux-foundation.org>
References: <1303963411-2064-1-git-send-email-john.stultz@linaro.org>
	<1303963411-2064-4-git-send-email-john.stultz@linaro.org>
	<alpine.DEB.2.00.1104281426210.21665@chino.kir.corp.google.com>
	<20110504163657.52dca3fc.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also.  As direct access to current->comm is now verboten, we should add
a checkpatch rule to shout at people when they do it.

