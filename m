Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab1DEPwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:52:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46246 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011Ab1DEPwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:52:20 -0400
X-Sasl-enc: Ejr8/XVuMIYgGdDWMrgdnEyWzKlcwQFjTMZqdckYcXHW 1302018738
Message-ID: <4D9B3AA4.5090402@fastmail.fm>
Date: Tue, 05 Apr 2011 16:52:04 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/34] kbuild: Allow to override LINUX_COMPILE_BY and
 LINUX_COMPILE_HOST macros
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-8-git-send-email-mmarek@suse.cz>
In-Reply-To: <1302015561-21047-8-git-send-email-mmarek@suse.cz>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 15:58, Michal Marek wrote:
> -  echo \#define LINUX_COMPILE_BY \"`whoami`\"
> -  echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
> +  echo \#define LINUX_COMPILE_BY \"`echo $KBUILD_BUILD_USER | $UTS_TRUNCATE`\"
> +  echo \#define LINUX_COMPILE_HOST \"`echo $KBUILD_BUILD_HOST | $UTS_TRUNCATE`\"

Shouldn't these be the variables defined above otherwise we get empty
LINUX_COMPILE_{BY,HOST} in the case the corresponding environment
variable is unset.

Thanks,

Jack
