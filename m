Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2LRXKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 18:10:04 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:46448 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LRXKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 18:10:02 -0500
Date: Tue, 18 Dec 2012 23:43:56 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?utf-8?B?QmrDtnJu?= Christoph <einkaufenbc09@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.7.0 does not detect Realtek network card automatically
Message-ID: <20121218224356.GA28587@electric-eye.fr.zoreil.com>
References: <CAHOpdHVNK9=BKAJ_bnKmXY5Fm6NExSw9UhK-TB3=CdaRpwF_vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHOpdHVNK9=BKAJ_bnKmXY5Fm6NExSw9UhK-TB3=CdaRpwF_vw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Christoph <einkaufenbc09@googlemail.com> :
[...]
> Not sure what to do here. It's an Ubuntu kernel - should I take the
> one from the kernel GIT, compile it and activate some debugging or
> something to assist?

You should try to reproduce the problem with the kernel included r8169
driver and report any problem with it to netdev@vger.kernel.org.

-- 
Ueimor
