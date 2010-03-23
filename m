Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0CWGYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 02:24:11 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:53025 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0CWGYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 02:24:09 -0400
Date: Tue, 23 Mar 2010 07:24:03 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McClelland <mmcclell@bigfoot.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video: avoid NULL dereference
In-Reply-To: <20100322231441.b7e33bf9.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.1003230723150.8768@ask.diku.dk>
References: <Pine.LNX.4.64.1003212230380.12371@ask.diku.dk>
 <20100322231441.b7e33bf9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think we can pretty safely assume that we never get here with ov==NULL.
> 
> Oh well, I'll leave the test there for others to ponder.

OK.  I didn't read far enough in this email and sent another patch, in 
case it's useful.

julia
