Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2CMNeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:34:31 -0400
Received: from mail1.windriver.com ([147.11.146.13]:41747 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2CMNe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:34:29 -0400
Message-ID: <4F5F4C86.5050501@windriver.com>
Date: Tue, 13 Mar 2012 09:32:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: <stable@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable-review@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [34-longterm 020/196] staging: hv: use sync_bitops when interacting
 with the hypervisor
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com> <1331597724-31358-21-git-send-email-paul.gortmaker@windriver.com> <20120313070002.GA19629@aepfle.de>
In-Reply-To: <20120313070002.GA19629@aepfle.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-13 03:00 AM, Olaf Hering wrote:
> On Mon, Mar 12, Paul Gortmaker wrote:
> 
>> From: Olaf Hering <olaf@aepfle.de>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit 22356585712d1ff08fbfed152edd8b386873b238 upstream.
> 
> Unless there is a happy user of the hv drivers in this old kernel, it
> makes no sense to backport just this one patch.

There is no real way any of can tell just exactly who is using what
feature in what release.

> 
> I suggest to leave drivers/staging/hv alone in longterm releases, or
> backport the entire history of drivers/staging/hv up to 3.4.

I had actually thought of this in the past myself as well, but
in the end, decided to follow Greg's lead so at least it would
be consistent with what is/was done for 2.6.32

P.

> 
> Olaf
