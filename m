Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab2DZOU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:20:27 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:40685 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210Ab2DZOUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:20:25 -0400
Date: Thu, 26 Apr 2012 15:53:01 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Don Zickus <dzickus@redhat.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:core/locking] watchdog, hpwdt: Remove priority option for NMI callback
Message-ID: <20120426135301.GK6553@spo001.leaseweb.com>
References: <1333051877-15755-2-git-send-email-dzickus@redhat.com> <tip-09ee10143658cd021d879ead61ead72a196302b6@git.kernel.org> <20120426071339.GI6553@spo001.leaseweb.com> <20120426122659.GS28185@redhat.com> <9774516974AF5F4C8A2C3C69CD341233203A83B5@G9W0755.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9774516974AF5F4C8A2C3C69CD341233203A83B5@G9W0755.americas.hpqcorp.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> Wim:
> 
> 
> Don is correct. We did have a separate discussion about this after I denied the original patch. It is all good now.
> 
> And thanks for cutting in the port 0x72 patch.
> 
> Thanks,
> Tom 

Then this is also OK for me.
You can add an Acked-by me :-).

Kind regards,
Wim.

