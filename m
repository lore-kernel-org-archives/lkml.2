Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1EDCpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 22:45:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58732 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab1EDCpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 22:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hDHGwj2RoYryquL8DV/RFIv3HFaQNYymno6HRnGGX/8nSSoLjsUtFfYUdsetuV8Xp8
         qY+l6mMJwpSx5CIRNHX0a8iMaF+X5KYEOtTiq0fNv5ElyCGZvNMiooi3GDf7M+de10UV
         dvCrKHGRP6YLiE5A2mobPObAVP/Wz2ZY7w2vM=
MIME-Version: 1.0
Date: Wed, 4 May 2011 10:45:42 +0800
Message-ID: <BANLkTiko7N=1w+Z56vuDcAUw5cHwgPi=1g@mail.gmail.com>
Subject: COW page cache for file hole?
From: Dave Young <hidave.darkstar@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During test fengguang's readahead alloc-noretry patch, I have some thoughts

In the 1000 dd case, page cache of sparse file hole are all zero indeed.
So what about make a global zero page for that purpose, fs level know
it is a hole,
when write occurs on that page we can alloc a new page for that.

I have no enough knowledge to implement it so just give out the
question without patch, sorry.
BTW, was there any attempt for this before?

-- 
Regards
dave
