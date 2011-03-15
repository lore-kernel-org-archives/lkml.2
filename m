Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab1COCcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 22:32:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1COCcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 22:32:00 -0400
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=iMvQkSxJFt0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Zfj8Z6T3O8nDHP5mvgEA:9 a=D54Z0RRAqWySaSZLaPeTf-jU_PQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][rfc] Use int as return type of main in
 arch/x86/boot/main.c
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jesper Juhl <jj@chaosbits.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4D7E9BCC.5070204@zytor.com>
References: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net>
	 <20110314190317.GA20259@home.goodmis.org>  <4D7E9BCC.5070204@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 22:31:58 -0400
Message-ID: <1300156318.9910.243.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 15:50 -0700, H. Peter Anvin wrote:
> 
> Yes, but some versions of gcc complains about a nonstandard signature to
> main().  At least that's what I assume Jesper's issue was. 

OK, but I prefer the solution you suggested. Let's just rename it.

-- Steve


