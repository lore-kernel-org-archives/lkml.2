Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0KXEqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 23:46:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38850 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab0KXEq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 23:46:29 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=yZSwoSqacEEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=9c2IHmghZpjsmL6uAsYA:9 a=dklcz_VCjfoY6ll357H4h2ZTehgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] isdn: icn: Fix stack overflow bug
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Karsten Keil <isdn@linux-pingi.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1290573578.30543.461.camel@gandalf.stny.rr.com>
References: <1290573578.30543.461.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 23:46:27 -0500
Message-ID: <1290573987.30543.462.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note, the subject should really be:

[PATCH] isdn: icn: Fix stack corruption bug.

-- Steve


