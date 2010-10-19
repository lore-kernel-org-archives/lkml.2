Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0JSQzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:55:06 -0400
Received: from caprica.metux.de ([82.165.128.25]:34985 "EHLO
	mailgate.caprica.metux.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756082Ab0JSQzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:55:05 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2010 12:55:05 EDT
Date: Tue, 19 Oct 2010 18:41:08 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: cluster machines with per-CPU local memory (one step beyond numa ?;-))
Message-ID: <20101019164108.GA26842@nibiru.local>
Reply-To: weigelt@metux.de
Mail-Followup-To: linux kernel list <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,


suppose we have a machine that consists a bunch of CPUs which
have local memory (directly tied to the core, w/o additional
caches) and either an slower shared memory or some DMA interlink
(which only works on page granularity).

Can Linux yet utilize such an machine ? How is this done ?
Or how could it be done ?


cu
-- 
----------------------------------------------------------------------
 Enrico Weigelt, metux IT service -- http://www.metux.de/

 phone:  +49 36207 519931  email: weigelt@metux.de
 mobile: +49 151 27565287  icq:   210169427         skype: nekrad666
----------------------------------------------------------------------
 Embedded-Linux / Portierung / Opensource-QM / Verteilte Systeme
----------------------------------------------------------------------
