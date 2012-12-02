Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2LBO2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 09:28:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54338 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2LBO2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 09:28:08 -0500
Date: Sun, 2 Dec 2012 06:28:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] mm, percpu: Make sure percpu_alloc early parameter has
 an argument
Message-ID: <20121202142802.GS15930@mtj.dyndns.org>
References: <20121124211713.GA22236@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121124211713.GA22236@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2012 at 01:17:13AM +0400, Cyrill Gorcunov wrote:
> Otherwise we are getting a nil dereference
> 
>  | [    0.000000] BUG: unable to handle kernel NULL pointer dereference at           (null)
>  | [    0.000000] IP: [<ffffffff81391360>] strcmp+0x10/0x30
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Applied to percpu/for-3.8.  Thanks!

-- 
tejun
