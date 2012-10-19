Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab2JSPNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:13:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:50614 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2JSPNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:13:54 -0400
Message-ID: <1350659619.2768.30.camel@twins>
Subject: Re: [PATCH 1/2] perf tools: add event modifier to request exclusive
 PMU access
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com
Date: Fri, 19 Oct 2012 17:13:39 +0200
In-Reply-To: <1350658326-14715-2-git-send-email-eranian@google.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
	 <1350658326-14715-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 16:52 +0200, Stephane Eranian wrote:
> -modifier_event [ukhpGH]{1,8}
> +modifier_event [ukhpGHx]{1,8} 

wouldn't the max modifier sting length grow by adding another possible
modifier?
