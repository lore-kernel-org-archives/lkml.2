Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1HSQU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:20:27 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:42373 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab1HSQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:20:26 -0400
MIME-Version: 1.0
In-Reply-To: <4E4B181E.8000508@cn.fujitsu.com>
References: <CAPL5yKdvMtCo8qqqJGM-FXk7CmhkY98QeDa8uH=ZDFLjus7Wng@mail.gmail.com>
	<1313499055-sup-2296@shiny>
	<CAPL5yKc7wztLatbk-4sVDnTLeiSeeXaXZd45r_rxDhdtR3mtPg@mail.gmail.com>
	<4E4B181E.8000508@cn.fujitsu.com>
Date: Fri, 19 Aug 2011 12:20:24 -0400
Message-ID: <CAPL5yKe8cu=_X8gHgd1DQu21uK7jqMLjQGaZwokmfxDqU-ESkQ@mail.gmail.com>
Subject: Re: processes stuck in llseek
From: Dan Merillat <dan.merillat@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BTRFS Mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here it is.
>
> http://marc.info/?l=linux-btrfs&m=131176036219732&w=2

That was it, thanks.   Confirmed fixed.
