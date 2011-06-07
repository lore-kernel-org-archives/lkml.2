Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1FGKn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:43:59 -0400
Received: from mail.bbaw.de ([194.95.188.6]:45957 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab1FGKn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:43:57 -0400
Date: Tue, 7 Jun 2011 12:43:54 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Message-Id: <20110607124354.06ed074e.taeuber@bbaw.de>
In-Reply-To: <20110606155610.69a0d17a.taeuber@bbaw.de>
References: <20110606095127.21d23a70.taeuber@bbaw.de>
	<201106060559.03131.gene.heskett@gmail.com>
	<20110606130628.e86f0c67.taeuber@bbaw.de>
	<201106060920.32257.gene.heskett@gmail.com>
	<20110606155610.69a0d17a.taeuber@bbaw.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.5.12; VDF: 7.11.9.67; host: mailhub); id=25431-wIesty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am Mon, 6 Jun 2011 15:56:10 +0200
Lars Täuber <taeuber@bbaw.de> schrieb:
> I sent an email to the WD support.

WD told me that the firmware versions I use are the newest available for the
models. Here is a list of models in the array:
Model          		Serial #    		Firmware
WDC WD2002FYPS-01U1B1   WD-WCAVY4757773         04.05G05

WDC WD2002FYPS-02W3B0   WD-WCAVY5361793         04.01G01
WDC WD2002FYPS-02W3B0   WD-WCAVY6201161         04.01G01
WDC WD2002FYPS-02W3B0   WD-WCAVY6252449         04.01G01
WDC WD2002FYPS-02W3B0   WD-WCAVY6408178         04.01G01

WDC WD2003FYYS-02W0B0   WD-WMAY01123610         01.01D01
WDC WD2003FYYS-02W0B0   WD-WMAY01800979         01.01D01
WDC WD2003FYYS-02W0B0   WD-WMAY02037927         01.01D01


I think it really is a kernel problem because I had the same problem also
with seagate drives for which also no newer firmware seems to be available.

What can I do to track this down?

Is there someone that can confirm this problem on different hardware? It
really is simple to test if you have six drives and a (relatively fast)
running system.

Thanks
Lars
