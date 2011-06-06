Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1FFPCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:02:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60550 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFPCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:02:46 -0400
Date: Mon, 6 Jun 2011 11:02:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Jones <pjones@redhat.com>
Cc: Connor Hansen <cmdkhh@gmail.com>, konrad@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iscsi_ibft_find unused variable i
Message-ID: <20110606150228.GC29243@dumpdata.com>
References: <1307270109-28635-1-git-send-email-cmdkhh@gmail.com>
 <4DECDF03.4070003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DECDF03.4070003@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DECEC13.00A7:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 10:06:59AM -0400, Peter Jones wrote:
> On 06/05/2011 06:35 AM, Connor Hansen wrote:
> > int i is only needed if CONFIG_ACPI is set
> > so move it within ifdef so kernels without ACPI
> > dont allocate space for nothing. Fixes warning too.
> > 
> > Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
> 
> Reasonable enough.
> 
> Signed-off-by: Peter Jones <pjones@redhat.com>

<nods> Queued up for 3.0-rc2
