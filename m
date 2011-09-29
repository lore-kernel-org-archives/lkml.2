Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1I2WXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:23:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab1I2WXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:23:24 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=xqWeJ7oWfF4GtCVPRd0A:9 a=5KeZ14jdl78wJ-32NpsA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: Jump Label initialization
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 29 Sep 2011 18:23:21 -0400
In-Reply-To: <4E84EF17.8040609@goop.org>
References: <4E83D49C.9080809@goop.org> <1317281879.22384.1.camel@twins>
	 <4E84EF17.8040609@goop.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317335003.4588.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 15:20 -0700, Jeremy Fitzhardinge wrote:
> +static void __jump_label_transform(struct jump_entry *entry,
> +                                  enum jump_label_type type,
> +                                  void *(*poker)(void *, const void *, size_t))
>  { 

Jump labels have taken up gambling?


-- Steve


