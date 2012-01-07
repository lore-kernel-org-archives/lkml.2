Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2AGKGB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 05:06:01 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:32921 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006Ab2AGKGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 05:06:00 -0500
Message-ID: <1325930757.14763.4.camel@joe2Laptop>
Subject: Re: [PATCH 4/6] x86: initial support for sta2x11
From: Joe Perches <joe@perches.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 07 Jan 2012 02:05:57 -0800
In-Reply-To: <20120107082212.GA18254@mail.gnudd.com>
References: <1325894723.12292.13.camel@joe2Laptop>
	 <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
	 <1446410617.668.1325893939253.JavaMail.mail@webmail05>
	 <20120107082212.GA18254@mail.gnudd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-07 at 09:22 +0100, Alessandro Rubini wrote:
> > or __func__
> I don't understand. No size? Or you typoed and meant pr_fmt defined above?

I meant that outputting __func__ (in this case
sta2x11_new_instance) doesn't gain much useful
information and generally isn't necessary.

> >> +	uint32_t v[2]; /* used as a string... */
> > less than pretty.
> Sure. But it's informative. Do you prefer a union?

Not really.


