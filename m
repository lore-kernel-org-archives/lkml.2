Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0HOQNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525Ab0HOQNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:13:16 -0400
Message-ID: <4C67CCE8.7060608@redhat.com>
Date: Sun, 15 Aug 2010 14:18:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH] kvm: destroy workqueue on kvm_create_pit() failures
References: <1281687786-3200-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1281687786-3200-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/13/2010 11:23 AM, Xiaotian Feng wrote:
> kernel needs to destroy workqueue if kvm_create_pit() fails, otherwise
> after pit is freed, the workqueue is leaked.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

