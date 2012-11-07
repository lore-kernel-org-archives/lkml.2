Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2KGU7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:59:41 -0500
Received: from smtprelay0112.b.hostedemail.com ([64.98.42.112]:55213 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752074Ab2KGU7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:59:40 -0500
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1260
Date: Wed, 7 Nov 2012 20:59:38 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: tiwai@suse.de
Cc: stern@rowland.harvard.edu, cmeerw@cmeerw.org, zonque@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Message-ID: <1709449499.279956.1352321978337.JavaMail.mail@webmail12>
References: <20121105191336.GA1404@edge.cmeerw.net>
 <Pine.LNX.4.44L0.1211071220230.1175-100000@iolanthe.rowland.org>
 <s5hzk2tfcg8.wl%tiwai@suse.de>
Subject: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [37.112.113.113]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 8, 2012, Takashi Iwai  wrote: 

> How about the patch below?  (It's for 3.6, and won't be applied cleanly
> to 3.7, but easy to adapt.)

This patch fixes my problem, thank you!

You can add me as "Tested by".

Artem
