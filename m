Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3ABPcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:32:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab3ABPcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:32:04 -0500
Message-ID: <50E452E2.7010601@redhat.com>
Date: Wed, 02 Jan 2013 10:31:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, Tom Herbert <therbert@google.com>
Subject: Re: [PATCH 1/2] x86,smp: simplify __ticket_spin_lock
References: <20121221184940.103c31ad@annuminas.surriel.com> <20130102000653.GA13678@google.com> <20130102000935.GB13678@google.com>
In-Reply-To: <20130102000935.GB13678@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2013 07:09 PM, Michel Lespinasse wrote:
> Just cosmetic - avoid an unnecessary goto construct
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

I have had this in my code base since you first suggested
it on December 21st. Thank you for sending in more improvements,
though :)

-- 
All rights reversed
