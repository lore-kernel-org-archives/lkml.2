Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab1KUUg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:36:26 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:32009 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab1KUUgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:36:24 -0500
Date: Mon, 21 Nov 2011 15:36:14 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: lower the dirty balance poll interval
Message-ID: <20111121203614.GE28259@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20111117122403.GA32363@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117122403.GA32363@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4ECAB647.0046,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 08:24:03PM +0800, Wu Fengguang wrote:
> Tests show that the original large intervals can easily make the dirty
> limit exceeded on 100 concurrent dd's. So adapt to as large as the
> next check point selected by the dirty throttling algorithm.

Thanks Wu, were you planning on pushing this through your tree or should
I take it?

-chris
