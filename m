Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0LIWUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:20:40 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:54812 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab0LIWUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:20:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=etouoXKtX4os6ZbugOS0kikuCfKUTq2h8ffAyRHYxD8HCcI2AbgC2CEI/8+niEloJ+
         moJccGxROGsbetWWwiq2sLxzCScpccSZKpqKaOOySPtZ3jhvA5XDDXtQmTp75F+sDIWM
         OTMNoLr9DBw/iGhZGKr630CsojaqlkDfQPsuQ=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 9 Dec 2010 14:20:17 -0800
Message-ID: <AANLkTik4W+UxgyPjVyHDeEFTRCkXdDBQ9obgPkpnhzGW@mail.gmail.com>
Subject: Start dropping PCMCIA from compat-wireless for 2.6.38+
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm going to start dropping PCMCIA stuff from compat-wireless as I
don't think we have any users of it nor interest to keep backporting
it. This entails dropping drivers like orinoco, b43 PCMCIA support,
libertas, as well as bluetooth bluecard_cs, bluecard_cs, dtl1_cs,
bt3c_cs and of course CONFIG_SSB_PCMCIAHOST. If you are a user please
yell now.

 Luis
