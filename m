Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2LXFFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 00:05:09 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:56940 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2LXFFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 00:05:07 -0500
Date: Sun, 23 Dec 2012 21:08:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v6] KSM: numa awareness sysfs knob
Message-ID: <20121224050817.GA25749@kroah.com>
References: <1356319374-13226-1-git-send-email-pholasek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356319374-13226-1-git-send-email-pholasek@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 04:22:54AM +0100, Petr Holasek wrote:
> Introduces new sysfs boolean knob /sys/kernel/mm/ksm/merge_across_nodes
> which control merging pages across different numa nodes.

All sysfs files must be documented in Documentation/ABI, please update
the files there as well (subsystem documentation, like you did, is also
nice, but the ABI files are the required ones.)

thanks,

greg k-h
