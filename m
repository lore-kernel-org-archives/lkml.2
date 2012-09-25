Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2IYX2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:28:31 -0400
Received: from blu0-omc4-s21.blu0.hotmail.com ([65.55.111.160]:46189 "EHLO
	blu0-omc4-s21.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259Ab2IYX21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:28:27 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 19:28:27 EDT
X-Originating-IP: [69.158.129.29]
X-EIP: [YloTBf91ElGrXDOCyc2krYGdYvDd24ao]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP54F29C73A16BAB0885137A979D0@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: Denys Vlasenko <vda.linux@googlemail.com>
In-Reply-To: <CAK1hOcMongS_p5+oiaqE85tEVF8mv+SCm3yb-N=Zqz4Xuz_+WA@mail.gmail.com>
Subject: Re: parisc: orphaned asm/compat_signal.h file?
References: <CAK1hOcMongS_p5+oiaqE85tEVF8mv+SCm3yb-N=Zqz4Xuz_+WA@mail.gmail.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Tue, 25 Sep 2012 19:23:03 -0400
CC: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 25 Sep 2012 23:23:19.0320 (UTC) FILETIME=[BF652180:01CD9B74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-Sep-12, at 8:39 AM, Denys Vlasenko wrote:

> Maybe it needs to be removed?

Worked for me with 3.5.4.

Dave
--
John David Anglin	dave.anglin@bell.net



