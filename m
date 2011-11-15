Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1KOASM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:18:12 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42003 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077Ab1KOASM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:18:12 -0500
Message-ID: <1321316290.7510.0.camel@Joe-Laptop>
Subject: Re: Printk mulitple line message support
From: Joe Perches <joe@perches.com>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Huang Ying <ying.huang@intel.com>,
        William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Nov 2011 16:18:10 -0800
In-Reply-To: <20111114192026.73afb5b8@neptune.home>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop> <20111114192026.73afb5b8@neptune.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 19:20 +0100, Bruno Prémont wrote:
> Wouldn't another option be to let printk() handle '\n' in messages
> so the multi-line messages could be done with a single call to printk.

That already happens.

