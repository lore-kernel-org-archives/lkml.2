Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2FDBfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:35:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56124 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab2FDBfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:35:06 -0400
Date: Mon, 4 Jun 2012 02:35:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: George Shuklin <george.shuklin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why minor is still 8 bit?
Message-ID: <20120604013504.GU30000@ZenIV.linux.org.uk>
References: <4FCC0E6D.9000206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCC0E6D.9000206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 05:25:01AM +0400, George Shuklin wrote:
> I've understand that major and minor numbers for device is 8-bit size.
> 
> I've don't understand, WHY? In 2012!
> 
> (I've just have some discussion about 8-bit counter limitations in
> context of cloud computing. In middle of 2012!!!!)

Yes, shocking.  It's been several years and you are still using that
buzzword; I mean, it's _so_ 2010...  Should've moved on to whatever's
in this year...

Incidentally, minors are 20 bit and majors are 12, but don't let that
stand in the way of righteous indignation - what's mere facts when
one is having discussions in context, presumably leveraging synergies
all along...
