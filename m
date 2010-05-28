Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0E1BkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:40:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49762 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab0E1BkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:40:08 -0400
Message-ID: <4BFF1F8A.6050506@cn.fujitsu.com>
Date: Fri, 28 May 2010 09:42:34 +0800
From: liubo <liubo2009@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>,
       linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs: do aio_write instead of write
References: <1274461422-18433-1-git-send-email-josef@redhat.com> <1274461422-18433-6-git-send-email-josef@redhat.com> <4BFDE1CE.4030100@cn.fujitsu.com> <20100527125952.GQ3108@think>
In-Reply-To: <20100527125952.GQ3108@think>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 08:59 PM, Chris Mason wrote:
> Thanks for sending along this test program and bug report.  We've fixed
> a few bugs in the O_DIRECT patches, and this is working now.
>
> The merged result is in the for-linus branch of the btrfs unstable tree.
>
> -chris
>   

Oh, Thanks a lot. I've see your great effort.

-liubo
