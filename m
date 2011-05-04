Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1EDNSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:18:07 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:58749 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab1EDNSF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:18:05 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 May 2011 09:18:05 EDT
X-AuditID: 12074422-b7b87ae000005e02-d3-4dc150e07322
Subject: Re: [PATCH 0/6] writeback fixes and trace events
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110504100609.GE9114@dastard>
Date: Wed, 4 May 2011 09:12:54 -0400
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <9B76908F-0E95-421A-8CDA-39B7AF7DA681@mit.edu>
References: <20110504091707.910929441@intel.com> <20110504094654.GA31151@infradead.org> <20110504095637.GA2101@localhost> <20110504100609.GE9114@dastard>
To: Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0gUYRTlmxnH8TE2jpqfa0aOlqKtJSSOIiGmsJSLQv2pCB3dyd3aHW1m
	V9QCZS0tbUEssDYRMzPZAsNdSML1hVmpiGCCkZhEEKuUkCRl9pjx/e983zn3nHu5l0DpMS8V
	YRDMvChwRgb3xWifkCj1fO6g9uiUh2Sbu57hrGtkDrBLX7pQdqyhDWEfNFUjbK/7LcZOvWzG
	0701o21Q4+yM0zzq9SCaN/d+Y5rx1mFvzXL3/lz8nF9aAWcuPW0oEo4cz/fTjzsdoOQuVuZy
	NWFVoBWtAz4EpI7B17M13ht4L5yc68IVTFN9AH5eSK0DvjLuArBm4A6+8ehE4Iit20tRBVEp
	cPn9jXUnkkqEj7tr151QKg7O/PUgCsYpBs5+78cU7EMdhlUrnnU9RkXDttUJVDFFqRYEOttv
	oxvF8bDj4eKmaSqcfzWxmXwfQLd7aT0hmDoEGxt7ZBEh9x0BrR36BhBo39WHfVcf9l22rQB1
	gAidqUJt4gxGiS9US4WcIPCiOinBZDAn8DpLN1CW4Z3J9IBfg8wQoAjA+JNZzICW9uJKpXLT
	EAgjECaE/JAzqKUDCop15XpO0ueJFiMvDQFIoEwwaWVljtRx5RW8WLxFhRMYE0o2h8VoaaqI
	M/OXeb6EF7fYfQTBQPKEfAB0oMgX8WUXDUbzDo0QPoq5rypY4gUdL3IWsz5P2XCeJK9Yofzl
	3GylnJRKOJP8u1E6CtSE49t4P6AxoVjgVaFkoSKiFJHeImxHbN3gAgiVJw4icxSVv3yh204L
	cggih5ysHlBCzNwOpaoCpWUVw1GVacg0QddqXWjM11Ws/VrkFSeOuf95TmW/Gw9I+HiGCah9
	6qikLuATL9ZuLh6sjesz8ufDE662iLcm69XLEcjZ57YQ3Ux+5oG6PfGRsRDJsGXgabbrP7BL
	09FrSYtskj25Pis5liUdn2KepBdY7dY/xXTKSuPPAAaT9FxiHCpK3H977r8YXgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4, 2011, at 6:06 AM, Dave Chinner wrote:

> Does anyone actaully testing filesystems use the -mm tree? I'm
> pretty sure that no-one in the XFS world does, and I don't think
> that any ext4 or btrfs folk do, either....

I don't.   I agree that it really would be great if there was a separate git tree for the writeback changes, since that way it becomes possible to test just the writeback changes, and not worry about other potential stability problems introduced by changes in the -mm tree....

-- Ted

