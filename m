Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab0J1RbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:31:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0J1RbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:31:10 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=XRlQGgV7sb0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8B_Zd0MxBC68SoALtLAA:9 a=GUVIfecJOtQYTYVFGevP-vTfBukA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Fix missing dependency of PCH_GBE driver
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, error27@gmail.com,
        masa-korg@dsn.okisemi.com, akpm@linux-foundation.org
In-Reply-To: <20101028.101618.226776102.davem@davemloft.net>
References: <1288268189.18238.173.camel@gandalf.stny.rr.com>
	 <20101028.101618.226776102.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Oct 2010 13:31:07 -0400
Message-ID: <1288287067.18238.272.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 10:16 -0700, David Miller wrote:

> The canonical way to handle this is to use 'select'.  Thus,
> I've committed the following to fix this.

Yeah, I was thinking that too after I posted it.

-- Steve


