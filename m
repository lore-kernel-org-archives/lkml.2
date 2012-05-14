Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2ENJCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:02:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45602 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2ENJCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:02:22 -0400
Date: Mon, 14 May 2012 12:04:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: volokh@telros.ru
Cc: devel@driverdev.osuosl.org, dhowells@redhat.com, my84@bk.ru,
        gregkh@linuxfoundation.org, Volokh Konstantin <volokh84@gmail.com>,
        linux-kernel@vger.kernel.org, mchehab@infradead.org,
        hverkuil@xs4all.nl, justinmattock@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: media: go7007: Adlink MPG24 board
Message-ID: <20120514090415.GG16984@mwanda>
References: <1336935162-5068-1-git-send-email-volokh84@gmail.com>
 <20120513192148.GE16984@mwanda>
 <20120514080918.GC1497@VPir.telros.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120514080918.GC1497@VPir.telros.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 12:09:18PM +0400, volokh@telros.ru wrote:
> It`s very horrible to describe every changing...

Maybe, but that's the rules.  There has to be a reason for every
change otherwise why are you doing crap for no reason?

It's not hard to break changes up into separate commits by the way.
Just use "git citool", highlight the lines you want, right click,
and choose "commit selected lines".

regards,
dan carpenter
