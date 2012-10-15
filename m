Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2JOA2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 20:28:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2JOA2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 20:28:18 -0400
Date: Mon, 15 Oct 2012 08:39:17 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        david@fromorbit.com, dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [RFC v3 00/13] vfs: hot data tracking
Message-ID: <20121015003917.GB23324@gmail.com>
Mail-Followup-To: zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 06:07:22PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> NOTE:
> 
>   The patchset is currently post out mainly to make sure
> it is going in the correct direction and hope to get some
> helpful comments from other guys.
>   For more infomation, please check hot_tracking.txt in Documentation

Hi Zhi Yong,

If I want to use this patch set in ext4, could I apply this patch set
directly or I need to call some functions like in btrfs.  Thanks.

Regards,
Zheng
