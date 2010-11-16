Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab0KPD16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:27:58 -0500
Received: from caprica.metux.de ([82.165.128.25]:33573 "EHLO
	mailgate.caprica.metux.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755576Ab0KPD15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:27:57 -0500
Date: Tue, 16 Nov 2010 04:14:30 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] device-core: sysfs open - close notify
Message-ID: <20101116031429.GA643@nibiru.local>
Reply-To: weigelt@metux.de
Mail-Followup-To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1288529170-28890-1-git-send-email-samu.p.onkalo@nokia.com> <AANLkTikRSF-4o=Jnyg2_Wa4gg7E+s_tM9ZD3g+f7hyWm@mail.gmail.com> <20101101171126.1194e2b0@linux.intel.com> <1288679408.2080.18.camel@noppispoppis.nmp.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288679408.2080.18.camel@noppispoppis.nmp.nokia.com>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ,
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42,
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida,
X-Killer: 23, endloesung, Weltuntergang,
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Onkalo Samu <samu.p.onkalo@nokia.com> wrote:

<snip />

Perhaps it also could be an more generic event notification op,
where some event id or bitmask tells what actually happened ?
Something like:

    ...
    void (*notify)(struct kobject *, struct attribute *, int event, void * param);
    ...

That would at least save one ptr of space and can be extended for
other stuff later.


cu
-- 
----------------------------------------------------------------------
 Enrico Weigelt, metux IT service -- http://www.metux.de/

 phone:  +49 36207 519931  email: weigelt@metux.de
 mobile: +49 151 27565287  icq:   210169427         skype: nekrad666
----------------------------------------------------------------------
 Embedded-Linux / Portierung / Opensource-QM / Verteilte Systeme
----------------------------------------------------------------------
