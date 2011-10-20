Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1JTVKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:10:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32902 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1JTVJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:09:57 -0400
Date: Thu, 20 Oct 2011 14:09:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] blk-throttle: Free up policy node associated with
 deleted rule
Message-ID: <20111020210952.GX25124@google.com>
References: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 20, 2011 at 05:08:25PM -0400, Vivek Goyal wrote:
> If a rule is being deleted, free up associated policy node. Otherwise
> that memory is leaked.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Heh, yeah, have the exactly same patch in my queue.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
