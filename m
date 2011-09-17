Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1IQRbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 13:31:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36553 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1IQRa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 13:30:59 -0400
Date: Sat, 17 Sep 2011 20:28:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Ramesh Raj <ramesh.v.raj@gmail.com>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, hjk@linutronix.de, jkosina@suse.cz,
        gregkh@suse.de, blp@cs.stanford.edu, linux-kernel@vger.kernel.org,
        abbotti@mev.co.uk, justinmattock@gmail.com
Subject: Re: [PATCH] staging: comedi: fixed checkpatch errors and curly brace
 issues
Message-ID: <20110917172830.GC9292@shale.localdomain>
References: <1316212273-14940-1-git-send-email-ramesh.v.raj@gmail.com>
 <alpine.LNX.2.00.1109171127240.2509@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1109171127240.2509@nippy.intranet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Churn is actually OK for staging drivers.  It's sort of the point of
staging in fact.

Sorry you were included on the CC list improperly.  get_maintainers.pl
got confused from a trivial patch across multiple subsystems.

Ramesh, ignore the comments that say "Churn" and fix the rest and
resend.  Don't CC Finn Thain.  Also while you're at it, don't CC
linux-kernel (they don't care about white space fixes).

regards,
dan carpenter

