Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab0HNQLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 12:11:38 -0400
Received: from mxo.volny.cz ([195.250.128.90]:62317 "EHLO mxo.volny.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab0HNQLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 12:11:37 -0400
X-Greylist: delayed 1309 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Aug 2010 12:11:37 EDT
MIME-Version: 1.0
Subject: =?iso-8859-2?Q?Re:_Call_traces_w/_2.6.35.2_=28not_w/_2.6.35.1_plus_2.6.35.2-rc1=29?=
From: wylda@volny.cz
X-Originating-Account: wylda/volny.cz
To: sedat.dilek@googlemail.com, gregkh@suse.de, linux-kernel@vger.kernel.org
Date: Sat, 14 Aug 2010 17:49:44 +0200 (CEST)
Message-ID: <be76a5088253ba67f809e5e4db07807a@www3-mail.volny.cz>
X-Mailer: Volny.cz Webmail2 2.147
X-Originating-Ip: 77.48.63.226
X-Originating-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; cs; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 (.NET CLR 3.5.30729)
X-Webmail2-Origin: wylda/volny.cz [77.48.63.226]
X-Priority: 3
In-Reply-To: <AANLkTi=+=2GEiC_WASfxC2u_xeTe4xdrZzLBs5Q1j3b7@mail.gmail.com>
References: <AANLkTi=YL_VKKDU8ok=OYotPhyQcGsVB2O-PU29+70YT@mail.gmail.com> <20100814134254.GC17430@suse.de> <AANLkTi=+=2GEiC_WASfxC2u_xeTe4xdrZzLBs5Q1j3b7@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Shall I open a separate BR for 2.6.35-gitX?

No it's not necessary. Leaving a comment under a bisected bugreport
is enough. Notice comment #0 stating, that all the latest stable
come with this regression - no need to open a new bug for each
version.

W.

> - Sedat -

PS: Wylda ("He";) is a nickname, so none of First or Surname...


