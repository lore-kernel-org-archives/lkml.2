Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab0HRQgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:36:00 -0400
Received: from www84.your-server.de ([213.133.104.84]:58912 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0HRQf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:35:57 -0400
Subject: Re: number of elements or bytes for kfifo_in etc
From: Stefani Seibold <stefani@seibold.net>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282109365.2744.1549.camel@yhuang-dev>
References: <1282109365.2744.1549.camel@yhuang-dev>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 18 Aug 2010 18:35:58 +0200
Message-ID: <1282149358.5103.5.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 18.08.2010, 13:29 +0800 schrieb Huang Ying:
> Hi, Stefani,
> 
> In new kfifo implementation in 2.6.36-rc1, description of the third
> parameter is:
> 
> "@n: number of elements to be added"
> 
> But if my understanding is correct, the actual implementation is:
> 
> "@n: number of bytes to be added"
> 

Number of bytes is wrong, this is only valid for byte stream fifo's
where an element is a byte.

Have a look at samples/kfifo/inttype-example.c where an element is a int
type.



