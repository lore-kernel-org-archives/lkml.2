Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0DZWM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:12:28 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:42295 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753197Ab0DZWM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:12:26 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2010 18:12:25 EDT
Date: Tue, 27 Apr 2010 00:05:43 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/7] Fix performance issue with ondemand governor
Message-ID: <20100426220543.GA27341@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
	cpufreq@vger.kernel.org
References: <20100418115949.7b743898@infradead.org> <20100426214156.GA32326@redhat.com> <20100426214534.GA5346@comet.dominikbrodowski.net> <4BD60CCB.7040907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD60CCB.7040907@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 05:59:39PM -0400, Rik van Riel wrote:
> On 04/26/2010 05:45 PM, Dominik Brodowski wrote:
>
>>> given the scheduler changes, these probably make more sense to go
>>> via one of Ingo's trees ?
>>> If everyone agrees, feel free to add my Signed-off-by:
>>
>> What about the issue Pavel reported and Willy confirmed (regression
>> on older hardware)?
>
> Having a /sys tunable makes sense, especially when running
> on battery power.  I guess that can be introduced as a patch
> 8/7 :)

... only if combined with sane default values.

Best,
	Dominik
