Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782Ab0HEG7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:59:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58244 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759705Ab0HEG7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:59:19 -0400
Date: Thu, 5 Aug 2010 08:59:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Josh Hunt <johunt@akamai.com>
Cc: oprofile-list@lists.sf.net, robert.richter@amd.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, juhlenko@akamai.com
Subject: Re: [PATCH] oprofile: add support for Intel processor model 30
Message-ID: <20100805065913.GA29966@basil.fritz.box>
References: <1280968025-16969-1-git-send-email-johunt@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280968025-16969-1-git-send-email-johunt@akamai.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tested using oprofile 0.9.6.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Reviewed-by: Andi Kleen <ak@linux.intel.com>

This change is ok since it's a 45nm Nehalem Xeon.

-Andi
