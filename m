Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2ACSop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:44:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:58528 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2ACSom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:44:42 -0500
Date: Tue, 3 Jan 2012 13:42:26 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] drivers/xen/gntalloc.c: introduce missing kfree
Message-ID: <20120103184226.GA27508@phenom.dumpdata.com>
References: <1324661974-17281-4-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324661974-17281-4-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F034C74.0142,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 06:39:29PM +0100, Julia Lawall wrote:
> Error handling code following a kmalloc should free the allocated data.
> Out_unlock is used on both success and failure, so free vm_priv before
> jumping to that label.

Applied. Thanks!
