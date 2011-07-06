Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1GFJAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:00:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab1GFJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:00:50 -0400
Date: Wed, 6 Jul 2011 02:01:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-mm@kvack.org, svaidy@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] mm,debug: VM framework to capture memory reference
 pattern
Message-Id: <20110706020103.53ed8706.akpm@linux-foundation.org>
In-Reply-To: <1309854159-8277-1-git-send-email-ankita@in.ibm.com>
References: <1309854159-8277-1-git-send-email-ankita@in.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Jul 2011 13:52:34 +0530 Ankita Garg <ankita@in.ibm.com> wrote:

> 
> This patch series is an instrumentation/debug infrastructure that captures
> the memory reference pattern of applications (workloads). 

Can't the interfaces described in Documentation/vm/pagemap.txt be used
for this?
