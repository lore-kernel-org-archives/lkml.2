Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621Ab2CVT4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:56:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56127 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964910Ab2CVT4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:56:06 -0400
Message-ID: <4F6B83D3.4000607@canonical.com>
Date: Thu, 22 Mar 2012 15:56:03 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Regression introduced in v3.2.12 stable
References: <4F6B7A37.3020300@canonical.com>
In-Reply-To: <4F6B7A37.3020300@canonical.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 03:15 PM, Joseph Salisbury wrote:
> Hello,
> 
> I figured I'd send a heads up regarding a possible regression in v3.2.12
> stable.  The issue prevents systems from booting.
> 
> There have been a few bugs[0] reported against the Ubuntu kernel, which
> was recently rebased to 3.2.12.  We're in the process of bisecting now
> and will post an update..
> 
> Thanks,
> 
> Joe
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/961482
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

It's also been noted that this bug happens in the latest version of v3.3.
