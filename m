Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2GFJLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:11:04 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60110 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab2GFJKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:10:50 -0400
Message-ID: <4FF6A91D.60505@parallels.com>
Date: Fri, 6 Jul 2012 13:00:13 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] force dentry revalidation after namespace change
References: <1341496805-26394-1-git-send-email-glommer@parallels.com> <8762a1vl76.fsf@xmission.com>
In-Reply-To: <8762a1vl76.fsf@xmission.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 03:31 AM, Eric W. Biederman wrote:
> The important difference there it is the directory that the dirent is
> in that the type comes from.  Not the dirent itself.
> 
>> >  	/* The sysfs dirent has been deleted */
>> >  	if (sd->s_flags & SYSFS_FLAG_REMOVED)
>> >  		goto out_bad;
> Glauber.  Do you think you can fix your patch and resubmit.
> 
> Eric

Yes. In a quick test it seems to work. I'll resubmit shortly.


