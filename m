Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2DCJqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:46:46 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54323 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2DCJqp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 3 Apr 2012 05:46:45 -0400
Message-Id: <4F7AE321020000780007C456@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 03 Apr 2012 10:46:41 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 6/7] xen/setup: Make dom0_mem=XGB
 behavior be similar to classic Xen kernels.
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
 <1333139850-28456-7-git-send-email-konrad.wilk@oracle.com>
 <4F7ABBC4.4050106@citrix.com>
In-Reply-To: <4F7ABBC4.4050106@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.04.12 at 10:58, David Vrabel <david.vrabel@citrix.com> wrote:
> With your new behaviour it will no longer possible to specify an
> unlimited balloon but a limited number of initial pages.  This is
> behaviour that Jan said he used.

An unlimited balloon was never possible afaict (as that would have
implied setting up an "infinite" number of struct page instances at
boot time.

What I'm using is "dom0_mem=-<num>M" together with the kernel
option "mem=<num>G", such that max-balloon > initial alloc (usually
I set max-balloon to approximately the amount of memory in the
system, so the upper limit is "infinite" in the sense that I can't go
higher anyway, but it's not truly infinity).

Jan

