Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab2C2Rab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:30:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38435 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab2C2Ra1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:30:27 -0400
Message-ID: <4F749C26.60804@zytor.com>
Date: Thu, 29 Mar 2012 10:30:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Maarten ter Huurne <maarten@treewalker.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: Add kernel config option to omit this device.
References: <1333041724-20532-1-git-send-email-maarten@treewalker.org>
In-Reply-To: <1333041724-20532-1-git-send-email-maarten@treewalker.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 10:22 AM, Maarten ter Huurne wrote:
> Many systems don't need /dev/mem, so make it optional.
> It saves some space on embedded systems.
> 
> Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>

I would like to see it being modular if it is made optional.  I think
that would be the right thing anyway.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

