Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2JVOFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:05:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2JVOFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:05:33 -0400
Message-ID: <50855298.9010003@redhat.com>
Date: Mon, 22 Oct 2012 16:05:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] kvm, svm: Cleanup error statements
References: <1350757204-14547-1-git-send-email-bp@alien8.de>
In-Reply-To: <1350757204-14547-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2012 08:20 PM, Borislav Petkov wrote:
> Use __func__ instead of the function name in svm_hardware_enable since
> those things tend to get out of sync. This also slims down printk line
> length in conjunction with using pr_err.
> 
> No functionality change.
> 

Applied, thanks.


-- 
error compiling committee.c: too many arguments to function
