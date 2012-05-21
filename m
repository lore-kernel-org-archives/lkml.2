Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab2EUOtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:49:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab2EUOtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:49:20 -0400
Message-ID: <4FBA55E8.8060009@redhat.com>
Date: Mon, 21 May 2012 17:49:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: kvm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: make asm-generic/kvm_para.h have an ifdef __KERNEL__
 block
References: <1337363979-5121-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1337363979-5121-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 08:59 PM, Paul Gortmaker wrote:
> There are two functions in this asm-generic file.  Looking at
> other arch which do not use the generic version, these two fcns
> are within an #ifdef __KERNEL__ block, so make the generic one
> consistent with those.

Thanks, applied for 3.5.

-- 
error compiling committee.c: too many arguments to function

