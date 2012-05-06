Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2EFKIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 06:08:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab2EFKIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 06:08:09 -0400
Message-ID: <4FA64D85.1000609@redhat.com>
Date: Sun, 06 May 2012 13:08:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Add mmx movq emulation
References: <1336132029-13523-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1336132029-13523-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 02:47 PM, Joerg Roedel wrote:
> Add support to the MMX versions of the movq instructions to
> the instruction emulator. Also handle possible exceptions
> they may cause.

This is already in (cbe2c9d30, e59717550e).  Are you looking at master
instead of next?

Since you've just thought of the issues involved, I'd appreciate a
review of the commits above, both wrt correctness and maintainability.

In fact I already see one difference - my patches do reg &= 7, while
your patches generate #UD for %mm8-%mm15.

-- 
error compiling committee.c: too many arguments to function

