Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab1DDKjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:39:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35293 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1DDKjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GLWaf/wSSFIpGrJ5cy/eF34+EEYnfZoU+YU0OY/rlMpueXr44emjg1ycyzOtnR+J+W
         TviYNLj8ciVTDQMzPnzPrXBhjjmyHNB0UNXCmbMbIVXm7AVS2RodJXlCdZRWzjRIpowM
         wJUO47TvBlbsU2BaJPP2mlHjsUYlHOXcrmp7M=
Date: Mon, 4 Apr 2011 12:39:45 +0200
From: Johan Hovold <jhovold@gmail.com>
To: wanlong.gao@gmail.com
Cc: gregkh@suse.de, alan@linux.intel.com, tsozik@yahoo.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiaweiwei.xiyou@gmail.com
Subject: Re: [PATCH] USB:Fix the wrong function prototype .
Message-ID: <20110404103945.GB26045@localhost>
References: <1301912997-21248-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301912997-21248-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 06:29:57PM +0800, wanlong.gao@gmail.com wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> While the "mct_u232_device.ioctl" initialized by a wrong function
> prototype . And the argument "struct file *file" is unused in
> the function "mct_u232_ioctl()".

Thanks for the patch, but I believe there was patch submitted last
Friday which also fixes this issue:

	https://lkml.org/lkml/2011/4/3/74

Thanks,
Johan
