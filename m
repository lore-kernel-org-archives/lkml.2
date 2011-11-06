Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1KFLwn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 06:52:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33841 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab1KFLwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 06:52:42 -0500
Date: Sun, 6 Nov 2011 12:52:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, sergey.senozhatsky@gmail.com
Subject: Re: [PATCH 0/4] patches to cure race in lock_set_class()
Message-ID: <20111106115237.GA2524@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
	sergey.senozhatsky@gmail.com
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 05:26:26PM +0800, Yong Zhang wrote:
> This a new version of my previous post[1].
> 
> patch#1 is the one which fix the reported bug.
>   So Sergey, Borislav, would you please give it a test?

Yep, applied and running now, will let you know what happens.

Thanks.

-- 
Regards/Gruss,
   Boris
