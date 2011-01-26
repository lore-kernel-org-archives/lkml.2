Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1AZRnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:43:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56213 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1AZRnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:43:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cHFDqO82n9qwSXO3nD0IazigPBIFylwV98T5sz2NawaaTohFP/R3wnWlL6RdkUcdiW
         uYYP958mpAEJD1OgLh6drfCIjzfOa2e6CkKxopVqb9wOcr939j1cOyqZzWT1BUqhvgf7
         CsCBFmcM/D+QkBA+xlEfglTDQyj9GVJGnoaJI=
MIME-Version: 1.0
In-Reply-To: <20110126172706.GH8446@linux.vnet.ibm.com>
References: <20110126172148.GB8446@linux.vnet.ibm.com>
	<20110126172706.GH8446@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 19:43:12 +0200
X-Google-Sender-Auth: hskm2Us14pipeWn2DIq5WJoyeCA
Message-ID: <AANLkTinkdn2RjQi56Qzv=5+1swtG+kMhvUiAP42GeXNi@mail.gmail.com>
Subject: Re: [PATCH 6/7] zram/xvmalloc: Close 32byte hole on 64-bit CPUs
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 7:27 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> By swapping the total_pages statistic with the lock we close a
> hole in the structure for 64-bit CPUs.
>
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
