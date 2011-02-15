Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1BOMrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:47:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41865 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab1BOMrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:47:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=pJhNT0dpbtRfdCRiRt/xIefbc35JJv7Nn8jOVmMWtBViQy/WS3cAPaJFq6uG0EMuQV
         as3/iG1XeJDk56vKAdnvd+f5CP4MYPedjNj6HNWI2xIEg+moERn6/BZjnon1mBvx+uE3
         K28j65+I2bMIwVHf9ZPY6YNVhkzeqkAgfjgVs=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mcp23s08: support mcp23s17 variant
References: <1297699964-20527-1-git-send-email-jacmet@sunsite.dk>
	<AANLkTi=pWV+tfD6YGpKbzTkvLVoLXtGA41QRaaF=VFeq@mail.gmail.com>
	<87r5bacvvl.fsf@macbook.be.48ers.dk>
	<AANLkTikri_A1VknD3oLR2LwC4ysOgE20RnqMRdYnHbcP@mail.gmail.com>
Date: Tue, 15 Feb 2011 13:47:04 +0100
In-Reply-To: <AANLkTikri_A1VknD3oLR2LwC4ysOgE20RnqMRdYnHbcP@mail.gmail.com>
	(Grant Likely's message of "Mon, 14 Feb 2011 11:59:16 -0700")
Message-ID: <87mxlxa2if.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:

Hi,

 >> We could. I didn't do it because the 8bit and 16bit cases are very
 >> similar, and checking a simple integer is presumably a lot faster than
 >> the spi access - But I can rework the patch if you insists.

 Grant> I won't insist, but it really does look like something that should
 Grant> have separate accessors from a code maintenance perspective.

Ok, I've just respun the patch with seperate accessors.

 >> I wouldn't call it unrelated. It's to ensure it still lines up after the
 >> s/u8/unsigned/.

 Grant> Sorry, you're right.  I missed the s/u8/unsigned/ change.  I don't
 Grant> have any problem with whitespace changes in a hunk that is also
 Grant> getting a real change.

Ok, good.

-- 
Bye, Peter Korsgaard
