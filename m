Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1EXKZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:25:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34204 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1EXKZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:25:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=iI2S8p9Ky4ZdcaEazIO0oyi+lirsEN9dNzwR140Zl8ez89JtUMzm+aDCZwu4xswAW+
         +73IF8ZOfnbtyO82z3TT+QHyLlWX6DiX5ZnjiRuEklgktW2ZXYRXULarOsC9Hsh4NUii
         1ubS6yLApSQCdhKfw2UCkIDey5RLx8YhjJYnQ=
MIME-Version: 1.0
In-Reply-To: <4DDB81FD.2020903@broadcom.com>
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
	<20110522122325.108b1c86@lxorguk.ukuu.org.uk>
	<4DD905CC.8040407@broadcom.com>
	<20110522151959.7fd6e87e@lxorguk.ukuu.org.uk>
	<4DDB622B.1050005@broadcom.com>
	<20110524104404.336c765f@lxorguk.ukuu.org.uk>
	<4DDB81FD.2020903@broadcom.com>
Date: Tue, 24 May 2011 12:25:46 +0200
Message-ID: <BANLkTinDvRx67vz8TfqPGod2X9QSctH0Zg@mail.gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8 algorithm
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm out of topic, but you can take a look at drivers/ssb/pci.c

We implement crc checksum here as well. The same will be soon needed
for bcma (i've already done this locally).

-- 
Rafał
