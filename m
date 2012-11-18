Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2KROaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:30:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33355 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2KROaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:07 -0500
Date: Sun, 18 Nov 2012 06:30:02 -0800
From: Tejun Heo <tj@kernel.org>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] cuse: do not register multiple devices with
 identical names
Message-ID: <20121118143002.GH7306@mtj.dyndns.org>
References: <1353152748-6867-1-git-send-email-dh.herrmann@googlemail.com>
 <1353152748-6867-2-git-send-email-dh.herrmann@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353152748-6867-2-git-send-email-dh.herrmann@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 12:45:48PM +0100, David Herrmann wrote:
> Sysfs doesn't allow two devices with the same name, but we register a
> sysfs entry for each cuse device without checking for name collisions.
> This extends the registration to first check whether the name was already
> registered.
> 
> To avoid race-conditions between the name-check and linking the device, we
> need to protect the whole registration with a mutex.
> 
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
