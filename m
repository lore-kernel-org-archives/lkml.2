Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1LYJxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 04:53:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1LYJxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 04:53:35 -0500
Message-ID: <4EF6F29B.4070107@redhat.com>
Date: Sun, 25 Dec 2011 11:53:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: hamo.by@gmail.com
CC: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix undeclared MAY_{READ,WRITE,ACCESS}
References: <1324705595-4035-1-git-send-email-hamo.by@gmail.com>
In-Reply-To: <1324705595-4035-1-git-send-email-hamo.by@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2011 07:46 AM, hamo.by@gmail.com wrote:
> From: Yang Bai <hamo.by@gmail.com>
>
> commit 08a95a511af91a2a6c42f2a8f13b99402a39e84b checks
> device assignment permission but forgot to include the
> definition of MAY_{READ,WRITE,ACCESS} in linux/fs.h
> Include it and this fix the build error here:
> http://buildbot.b1-systems.de/kvm/builders/i386/builds/401
>
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

