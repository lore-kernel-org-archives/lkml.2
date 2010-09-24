Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0IXJ1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:27:37 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51673 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0IXJ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BseCgE9D9wlG8pi5qCI/irrcwoYl+dZkVWL6ot9aWH1NrhYyt/MQpfHEra4sepEndm
         EPPBet1J8E/W7G58dyk/hXuGyXs7pzDPt1XmTzb8sv/VMCIOY4jV/AJOC3SJb5D+2hyV
         kJ5t62kBIZ2j1JHj4FqmP3cudpMuIz7gFbmko=
Date: Fri, 24 Sep 2010 17:32:06 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kconfig: Use PATH_MAX instead of 128 for path buffer
 sizes.
Message-ID: <20100924093206.GD5453@cr0.nay.redhat.com>
References: <AANLkTinwXj92VLVYqDhvUAusY_MdBQPAYnGBKVgfNLrO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinwXj92VLVYqDhvUAusY_MdBQPAYnGBKVgfNLrO@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 03:59:13PM +0100, Will Newton wrote:
>This prevents the buffers being overflowed when using a config
>file with a long name. PATH_MAX is used elsewhere in the same
>file, so use it here as well.
>
>Signed-off-by: Will Newton <will.newton@imgtec.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
