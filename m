Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1HPV1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:27:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50326 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465Ab1HPV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:27:52 -0400
Subject: Re: [PATCH] powerpc/eeh: remove eeh_event_handler()->daemonize()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110816190858.GA4890@redhat.com>
References: <20110816190858.GA4890@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 22:27:49 +0100
Message-ID: <1313530069.3436.206.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 21:08 +0200, Oleg Nesterov wrote:
> daemonize() is only needed when a user-space task does kernel_thread().
> 
> eeh_event_handler() thread is created by the worker kthread, and thus
> it doesn't need the soon-to-be-deprecated daemonize().
> 
> Note: looks like eeh_event_wq can be static and it can do all work
> itself without kernel_thread().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Matt Fleming <matt.fleming@intel.com>


