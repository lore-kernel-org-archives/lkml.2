Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2HCUVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 16:21:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab2HCUVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 16:21:17 -0400
Message-ID: <1344025273.8003.40.camel@ul30vt>
Subject: Re: oops in pci_acs_path_enabled
From: Alex Williamson <alex.williamson@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 03 Aug 2012 14:21:13 -0600
In-Reply-To: <501C0CDF.7010804@gmail.com>
References: <501C0CDF.7010804@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 11:39 -0600, David Ahern wrote:
> Hi Alex:
> 
> Hitting an oops with 3.6-rc1. Backtrace from console attached. git blame 
> for the top function points to ad805758.

Hey David,

Hmm, what's special about your system?  I've got an 82576 here and the
same path works fine.  Any way you can get the top of the oops message?
Thanks,

Alex

