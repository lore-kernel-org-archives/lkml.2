Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0FNIFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:05:38 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:55758 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0FNIFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:05:35 -0400
Date: Mon, 14 Jun 2010 10:05:32 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linux RDMA <linux-rdma@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Subject: Re: [PATCH] ib/ehca: bitmask handling for lock_hcalls
Message-ID: <20100614100532.096c29d0@alex-laptop>
In-Reply-To: <adatyp9y2u4.fsf@roland-alpha.cisco.com>
References: <20100610110653.17885a81@alex-laptop>
	<adatyp9y2u4.fsf@roland-alpha.cisco.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 09:02:43 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> What is the impact of this problem?  ie is this something we need to fix
> for 2.6.35?  I suppose not, since the current code has been there a long time.

Right, we are okay with integrating this into 2.6.36, thanks!
