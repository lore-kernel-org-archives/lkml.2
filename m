Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab1D0Qph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:45:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37758 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1D0Qpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:45:36 -0400
Subject: Re: [PATCH] mm: Delete non-atomic mm counter implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
In-Reply-To: <1303914965-868-1-git-send-email-matt@console-pimps.org>
References: <1303914965-868-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 27 Apr 2011 09:08:18 -0700
Message-ID: <1303920498.9308.19700.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 15:36 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@linux.intel.com>
> 
> The problem with having two different types of counters is that
> developers adding new code need to keep in mind whether it's safe to
> use both the atomic and non-atomic implementations. For example, when
> adding new callers of the *_mm_counter() functions a developer needs
> to ensure that those paths are always executed with page_table_lock
> held, in case we're using the non-atomic implementation of mm
> counters.

> Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
> ---
> 
> Dave, you might want to take this into your pagetable counters series
> so that you only need to worry about atomic mm counters.

Thanks for doing the patch.  I'll certainly pick it up and submit it
alongside my stuff unless Andrew picks it up first.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>


-- Dave

