Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2BMK3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:29:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab2BMK3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:29:17 -0500
Message-ID: <4F38E5F4.9070009@redhat.com>
Date: Mon, 13 Feb 2012 11:29:08 +0100
From: Harald Hoyer <harald@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>, initramfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, systemd-devel@lists.freedesktop.org,
        selinux@lists.fedoraproject.org, Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: dracut: ordering of modules
References: <1328886121.2472.19.camel@falcor> <4F38DEF0.8010202@redhat.com> <4F38E337.7030200@polito.it>
In-Reply-To: <4F38E337.7030200@polito.it>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.02.2012 11:17, schrieb Roberto Sassu:
> Hi Harald
> 
> this functionality seems to be broken in dracut due to a change in the
> SELinux load_policy tool.
> After enabling the selinux module in dracut, i obtain:
> 
> [    3.369059] dracut: Loading SELinux policy
> [    3.449850] dracut: /sbin/load_policy: Can't load policy: No such file or
> directory
> [    3.659899] dracut: Switching root
> 

This error can have multiple causes... Dan?
