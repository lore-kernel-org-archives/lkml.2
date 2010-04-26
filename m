Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0DZWAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:00:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab0DZV76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:59:58 -0400
Message-ID: <4BD60CCB.7040907@redhat.com>
Date: Mon, 26 Apr 2010 17:59:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Dave Jones <davej@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/7] Fix performance issue with ondemand governor
References: <20100418115949.7b743898@infradead.org> <20100426214156.GA32326@redhat.com> <20100426214534.GA5346@comet.dominikbrodowski.net>
In-Reply-To: <20100426214534.GA5346@comet.dominikbrodowski.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 05:45 PM, Dominik Brodowski wrote:

>> given the scheduler changes, these probably make more sense to go
>> via one of Ingo's trees ?
>> If everyone agrees, feel free to add my Signed-off-by:
>
> What about the issue Pavel reported and Willy confirmed (regression
> on older hardware)?

Having a /sys tunable makes sense, especially when running
on battery power.  I guess that can be introduced as a patch
8/7 :)

-- 
All rights reversed
