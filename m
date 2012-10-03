Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2JCA7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:59:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33782 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2JCA7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:59:49 -0400
Date: Wed, 3 Oct 2012 09:59:39 +0900
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, cgroups@vger.kernel.org
Subject: Re: [PATCH 03/15] cfq-iosched: Rename "service_tree" to "st"
Message-ID: <20121003005939.GB15806@localhost>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-4-git-send-email-vgoyal@redhat.com>
 <x49ipatj4oy.fsf@segfault.boston.devel.redhat.com>
 <20121002132603.GB758@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002132603.GB758@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 02, 2012 at 09:26:03AM -0400, Vivek Goyal wrote:
> Yes this one is little odd. Ok, I will change it back to "service_tree"
> and only use "st" for local variables and in some function names.

Yes, please do that.  In general, it's beneficial to use at least
somewhat descriptive names for globals / struct fields and use
consistent shorthands for local variables dealing with them.

Thanks.

-- 
tejun
