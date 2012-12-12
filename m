Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2LLArM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:47:12 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55540 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab2LLArK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:47:10 -0500
MIME-Version: 1.0
In-Reply-To: <20121212014109.38e18eeb@neptune.home>
References: <CAGDELX7f-Ee-V_M8kbDONRFCTBbZM2H_Q17Bk_12r4xw85Wq4Q@mail.gmail.com>
	<20121212014109.38e18eeb@neptune.home>
Date: Wed, 12 Dec 2012 01:47:08 +0100
Message-ID: <CAGDELX6rtztDzQobfaUNB2iZSyxGL9vzu5mM4sG7bDip=SaBag@mail.gmail.com>
Subject: Re: "attempt to access beyond end of device" on DVD
From: Jacek Poplawski <jacekpoplawski@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/12, Bruno Prémont <bonbons@linux-vserver.org> wrote:
> When it happens, does ejecting and re-inserting the CDs/DVDs also fix the
> problem or is a full reboot mandatory?

The re-inserting doesn't fix the problem.
Even worse. When it starts - each next DVD is also affected (until reboot).
