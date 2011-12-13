Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1LMPoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:44:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47728 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab1LMPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:44:34 -0500
Date: Tue, 13 Dec 2011 07:44:28 -0800
From: Tejun Heo <tj@kernel.org>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Pavel Emelianov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
        lkml <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] resource cgroups: remove bogus cast
Message-ID: <20111213154428.GG25802@google.com>
References: <1323119621.3244.1.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323119621.3244.1.camel@offbook>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 10:13:41PM +0100, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> The memparse() function already accepts const char * as the parsing string.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Applied to cgroup/for-3.3 w/ Pavel's Acked-by.  Li Zefan, I committed
w/o your ack as the patch is trivial.  Please scream if you aren't
happy.

Thanks.

-- 
tejun
