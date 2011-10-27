Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1J0QK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:10:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35005 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1J0QKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:10:25 -0400
Date: Thu, 27 Oct 2011 09:10:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET block:for-3.2/core] rescue cfq from RCU death sprial
 :)
Message-ID: <20111027161019.GA29899@google.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <20111026213629.GJ24261@google.com>
 <20111027153239.GF7491@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111027153239.GF7491@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 11:32:39AM -0400, Vivek Goyal wrote:
> These changes look good to me. It simplifies the locking (yes despite
> double lock dance :-)) and gets rid of some race conditions.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Awesome, thanks.

-- 
tejun
