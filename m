Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0FWRbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:31:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:59979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab0FWRbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:31:51 -0400
Message-ID: <4C224502.2040206@kernel.org>
Date: Wed, 23 Jun 2010 19:31:46 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata link not reset properly
References: <4C223F8A.9030306@odi.ch> <4C224429.6010705@kernel.org>
In-Reply-To: <4C224429.6010705@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Jun 2010 17:31:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 07:28 PM, Tejun Heo wrote:
> Maybe we can use hardreset as the last resort before ditching the
> device.  Something like the following.  Can you please try it and post
> the kernel log?  Thanks.

Meh, it won't work.  It's failing softreset so we should be checking
reset try counts.  I'll try to write up something tomorrow.

Thanks.

-- 
tejun
