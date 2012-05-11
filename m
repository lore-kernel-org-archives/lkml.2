Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2EKGN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:13:56 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:54938 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2EKGNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:13:48 -0400
Message-ID: <4FACAE19.2070609@hrz.tu-chemnitz.de>
Date: Fri, 11 May 2012 08:13:45 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
References: <20120509220636.GA27659@kroah.com> <4FAAECB7.8070904@hrz.tu-chemnitz.de> <20120509222411.GA24302@kroah.com> <4FAAF1C4.2050500@hrz.tu-chemnitz.de> <20120509235723.GA7404@ioremap.net> <20120510000126.GA2357@kroah.com> <20120510004350.GA8362@ioremap.net> <4FAB4A4D.8080901@hrz.tu-chemnitz.de> <20120510151639.GE17472@kroah.com> <4FAC47F6.6080903@hrz.tu-chemnitz.de> <20120510230445.GA11918@kroah.com>
In-Reply-To: <20120510230445.GA11918@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scan-AV: cora.hrz.tu-chemnitz.de;2012-05-11 08:13:46;85a8c8ca5033c1db72cb9818c2df706f
X-Scan-SA: cora.hrz.tu-chemnitz.de;2012-05-11 08:13:46;30e31107ed59e302a166822235162661
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You forgot a Documentation/ABI/ update that shows your sysfs files and

> explains them there.


There is not even a single 1-wire driver mentioned within
Documentation/ABI. In which subdirectory shall I put my documentation
file into? stable?

@Evgeniy: Any suggestions?

Best regards,
Markus Franke
