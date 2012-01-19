Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2ASBSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:18:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45033 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2ASBSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:18:23 -0500
Date: Wed, 18 Jan 2012 17:18:18 -0800
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] blkcg: kill policy node and blkg->dev
Message-ID: <20120119011818.GE21533@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326935490-11827-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ooh, BTW, the percpu stats removal unfortunately will be near the end
of cleanups.  I tried to pull it at the head of cleanups but couldn't.
Dunno what to do about -stable.  :(

Thanks.

-- 
tejun
