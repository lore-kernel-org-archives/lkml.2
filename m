Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2JTWA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 18:00:59 -0400
Received: from smtprelay0045.b.hostedemail.com ([64.98.42.45]:53721 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251Ab2JTWA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 18:00:58 -0400
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1517
Date: Sat, 20 Oct 2012 22:00:57 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bp@alien8.de
Cc: linux-kernel@vger.kernel.org
Message-ID: <91806419.29616.1350770457292.JavaMail.mail@webmail07>
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020180437.GA9301@liondog.tnic>
Subject: Re: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [5.166.170.242]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can only reproduce this panic when my USB webcamera is plugged in - when
I click settings in Adobe Flash it sends some commands to my USB webcam using,
presumably, Video4Linux API calls which cause a kernel hard crash.

Your kernel debug features haven't helped at all, even the virtual machine
crashes the way I cannot get any information from it - under Windows 7 64
VirtualBox becomes an unkillable process.

I've no idea what's crashing - it can be the kernel itself, or some of v4l or usb
modules.

Artem
