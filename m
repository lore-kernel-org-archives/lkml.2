Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab1EKQQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:16:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab1EKQQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:16:11 -0400
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        johnstul@us.ibm.com, davidel@xmailserver.org, virtuoso@slind.org,
        tglx@linutronix.de, chris.friesen@genband.com, kirill@shutemov.name,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <BANLkTinFwmd-gEmSFpTuBg_dueXWGg5mxQ@mail.gmail.com>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
	 <1305109433.2914.208.camel@laptop>
	 <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
	 <1305121541.2914.213.camel@laptop>
	 <BANLkTik5szBkinZEWySVjBKA5GF+6dn8Yg@mail.gmail.com>
	 <1305122518.2914.224.camel@laptop>
	 <BANLkTim5WzcrzSiqhwXrhDDwcxF=JTpZew@mail.gmail.com>
	 <1305124250.2914.225.camel@laptop>
	 <BANLkTimvqAY9hwHujUVoQhN2eZQz-MVhgg@mail.gmail.com>
	 <1305125333.2914.229.camel@laptop>
	 <BANLkTi=aOsRs4iS_j41=NNESC2rgmwtpbg@mail.gmail.com>
	 <1305126680.2914.238.camel@laptop>
	 <BANLkTinFwmd-gEmSFpTuBg_dueXWGg5mxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 17:31:25 +0200
Message-ID: <1305127885.2914.241.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 17:17 +0200, Kay Sievers wrote:
> 
> If you think that needs to change, please discuss/provide
> alternatives, which we can check if they sufficiently work for us,
> like we did with this patch.

Since this is a published interface that's not the way things work,
first thing is to revert this to avoid us getting stuck with this crap.
> 
> But please stop rhetorically asking me if I want a slower kernel, and
> chance your tone. That will get us nowhere. 

Ah, we've got our patch and we'll stick to it no matter what the
consequences, very good attitude that.



