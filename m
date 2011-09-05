Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1IECfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 22:35:16 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60815 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1IECfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 22:35:12 -0400
Date: Mon, 5 Sep 2011 11:35:05 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] freezer: kill unused set_freezable_with_signal()
Message-ID: <20110905023505.GC9807@htj.dyndns.org>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
 <1314988070-12244-7-git-send-email-tj@kernel.org>
 <20110904184626.GA30101@redhat.com>
 <20110905023315.GB9807@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110905023315.GB9807@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 11:33:15AM +0900, Tejun Heo wrote:
> > So, yes, I am starting to think this change is fine too ;)
> 
> Yeay. :)

Ooh, can I add your Acked-by before sending pull request to Rafael?

Thanks.

-- 
tejun
