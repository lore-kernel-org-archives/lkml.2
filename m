Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1DOHdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 03:33:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49017 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1DOHdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 03:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OKmC9xbhxQtbFW90dSLEDxMOZRi7hYs2tVxbb9EeFsDH7mCj1iW1204lndT4yL+UAR
         lbp4Zy0qqczAVuAka+EBrlLwGE5Itrv9QxS0w/m9fszeo0MCohFQM05bREcmJowSufq6
         z51uq6IfCPx9MliSUWmmON9PPU3ZaOUFy3rgk=
MIME-Version: 1.0
In-Reply-To: <BANLkTim9iAM=d-aWxKySJTsUjvOyVLD0=A@mail.gmail.com>
References: <BANLkTim-KC7qfijD5rFNTR98GSs=cTPzJw@mail.gmail.com>
	<4DA75EA9.4050602@ece.ntua.gr>
	<BANLkTim9iAM=d-aWxKySJTsUjvOyVLD0=A@mail.gmail.com>
Date: Fri, 15 Apr 2011 04:33:06 -0300
X-Google-Sender-Auth: SDEjZcSYfGlNOM2KHWp7wDujCks
Message-ID: <BANLkTi=E0BO6dwNqPpOG5E9tz63J16EEDQ@mail.gmail.com>
Subject: Re: [REGRESSION] 2.6.32.36 - Linux Xen DomU doesn't boot anymore
From: "guilherme m. schroeder" <guilherme.m.schroeder@gmail.com>
To: Stratos Psomadakis <psomas@ece.ntua.gr>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32.37 fixed the regression.

Thanks.
