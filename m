Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0KIDmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:42:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0KIDmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:42:03 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=1qZAFK7FH7YA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VRQtJYKLSKnuBGqiJSoA:9 a=4zPjCKqRAZvzXE9iuQnPSP9CSnYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] powerpc: Add jump label support
From: Steven Rostedt <rostedt@goodmis.org>
To: michael@ellerman.id.au
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@ozlabs.org,
        jbaron@redhat.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>,
        Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1289273608.21111.194.camel@concordia>
References: <45fbc3cd7f6ce404d1e25bf01695fb629d86189d.1289189560.git.michael@ellerman.id.au>
	 <20101109133517.b6be28bf.sfr@canb.auug.org.au>
	 <1289273608.21111.194.camel@concordia>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 08 Nov 2010 22:41:59 -0500
Message-ID: <1289274119.12418.79.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 14:33 +1100, Michael Ellerman wrote:

> > You don't need this protection in a file that is not exported to user
> > space.
> 
> Ah true. I'll respin after I've heard if anyone has tested it :)

Don't wait for me. I'm stuck debugging some other crap. Getting a 4.5
PPC compiler working is very low on my priority list, unfortunately. :-(

-- Steve


