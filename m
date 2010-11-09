Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0KIObb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:31:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0KIOba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:31:30 -0500
Message-ID: <4CD95B32.9020105@redhat.com>
Date: Tue, 09 Nov 2010 16:31:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM x86: Makefile clean up
References: <1289069578-1907-1-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1289069578-1907-1-git-send-email-tdent48227@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2010 08:52 PM, Tracey Dent wrote:
> Changed makefile to use the ccflags-y option instead of EXTRA_CFLAGS.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

