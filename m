Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0DUKkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:40:07 -0400
Received: from mail-pz0-f186.google.com ([209.85.222.186]:60622 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab0DUKkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NPswvFRzrml+3iv9rWjx3eb8HFFScDLu718TB61nz/mJaSy1eHJWU01BuRVZeWONzO
         jFeA6OLMvJjL9+y6Vw8PXJsK92qAt+VXMxtWVNreqe2I66Yb1crpi8d0D7bfuXUQQ9Rk
         7+ODm2GhSlpITzoev6skpiidTX/btB/kblxNU=
Date: Wed, 21 Apr 2010 18:43:45 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Jan Kiszka <jan.kiszka@web.de>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/5] uml: Fix warning due to missing task_struct
 declaration
Message-ID: <20100421104345.GA4110@cr0.nay.redhat.com>
References: <cover.1271713955.git.jan.kiszka@web.de>
 <1d97cd7761a1eae73923b1adda4c6915a0647bb3.1271713955.git.jan.kiszka@web.de>
 <20100420100949.GB5317@cr0.nay.redhat.com>
 <20100420143016.GB30011@c-98-229-117-200.hsd1.ma.comcast.net>
 <4BCDDFBB.40805@web.de>
 <20100421060651.GB4467@cr0.nay.redhat.com>
 <alpine.LNX.2.00.1004211138320.7579@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004211138320.7579@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:38:53AM +0200, Jiri Kosina wrote:
>On Wed, 21 Apr 2010, Amerigo Wang wrote:
>> 
>> BTW, I don't think compile warning fixes are trivial enough to go
>> to trivial@kernel.org.
>
>Why?
>

Usually compile warnings fixes go into -mm, some coding style fixes
too.
