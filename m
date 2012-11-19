Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2KSHP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:15:56 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58096 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KSHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:15:55 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Tejun Heo <tj@kernel.org>
Cc: David Herrmann <dh.herrmann@googlemail.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] cuse: do not register multiple devices with identical names
References: <1353152748-6867-1-git-send-email-dh.herrmann@googlemail.com>
	<1353152748-6867-2-git-send-email-dh.herrmann@googlemail.com>
	<20121118143002.GH7306@mtj.dyndns.org>
Date: Mon, 19 Nov 2012 08:18:13 +0100
In-Reply-To: <20121118143002.GH7306@mtj.dyndns.org> (Tejun Heo's message of
	"Sun, 18 Nov 2012 06:30:02 -0800")
Message-ID: <87y5hy5adm.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> On Sat, Nov 17, 2012 at 12:45:48PM +0100, David Herrmann wrote:
>> Sysfs doesn't allow two devices with the same name, but we register a
>> sysfs entry for each cuse device without checking for name collisions.
>> This extends the registration to first check whether the name was already
>> registered.
>> 
>> To avoid race-conditions between the name-check and linking the device, we
>> need to protect the whole registration with a mutex.
>> 
>> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks, David.

Queued both patches for next tree.

Miklos
