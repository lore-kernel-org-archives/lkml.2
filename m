Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab0LMOJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:09:22 -0500
Received: from mail2.charite.de ([193.175.72.31]:57328 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757634Ab0LMOJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:09:21 -0500
Date: Mon, 13 Dec 2010 15:00:52 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Costly Context Switches
Message-ID: <20101213140052.GQ11368@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20101212151112.GE26583@charite.de>
 <201012122007.07372.andres@anarazel.de>
 <20101213135104.GE5407@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101213135104.GE5407@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:

> Better to record just "cs" (Context Switches) events and also to collect
> callchains when those events take place:
> 
> [acme@felicio ~]$ perf record -e cs -g chromium-browser


OK, I will try this. The application is dovecot-2.0, so I need to perf
record it and all it's children (imap, pop3, auth, etc). 

Is this done by default?

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12203 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  ralf.hildebrandt@charite.de | http://www.charite.de
	    
