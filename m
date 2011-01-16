Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1APKts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 05:49:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab1APKtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 05:49:47 -0500
Message-ID: <4D32CD45.3090503@redhat.com>
Date: Sun, 16 Jan 2011 12:49:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] perf-kvm support for SVM
References: <1295019902-31339-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1295019902-31339-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 05:45 PM, Joerg Roedel wrote:
> Hi,
>
> here is the reworked version of the patch-set. Only patch 1/2 has
> changed and now contains the real fix for the crashes that were seen and
> has an updated log message.
>

Thanks, applied.  2.6.37 and earlier aren't affected, yes?  So I'm 
queuing it for 2.6.38 only.

-- 
error compiling committee.c: too many arguments to function

