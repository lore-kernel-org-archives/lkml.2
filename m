Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab0LBOlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:41:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52461 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab0LBOlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:41:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=Ar11IFZMYopquvnLEXXxzJSc6AwDEaN1nzRW1sultAYngWNK8Kmair6k/xQ4y3chpF
         GXd3qPnVmo97cBWESMZocj9X5t47gH7TiAlVPikGmu6wgZ/DFFv1DxcXtZY6gDwofxpZ
         BhfsqxkU/hL6W8JGykU2Ml8xRylD/BPRX/p+I=
From: "Stanley Gan" <stanley.ganyezu@gmail.com>
To: "'Borislav Petkov'" <bp@alien8.de>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
References: <20101130153839.GM15818@bombadil.infradead.org> <4CF52652.4030802@kernel.org> <20101130163150.GA25668@bombadil.infradead.org> <20101130175317.GB25668@bombadil.infradead.org> <20101130210938.GF25668@bombadil.infradead.org> <4CF62EE0.7040607@kernel.org> <20101201124445.GG25668@bombadil.infradead.org> <4CF6595A.6010104@kernel.org> <20101201155026.GH25668@bombadil.infradead.org> <4cf79779.2b3bec0a.5180.1bb9@mx.google.com> <20101202131700.GA28343@a1.tnic>
In-Reply-To: <20101202131700.GA28343@a1.tnic>
Subject: =?UTF-8?Q?=E7=AD=94=E5=A4=8D:_debug_kernel_using_two_lapto?=
	=?UTF-8?Q?ps_without_serial_port?=
Date: Thu, 2 Dec 2010 22:41:03 +0800
Message-ID: <4cf7b004.8b3eec0a.7855.2255@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuSIza8SmxWrXlOTVy6JdoywCID3AACIFRA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,
	I will check your recommend document. Thank you so much.

Best wishes,
Stanley
-----邮件原件-----
发件人: Borislav Petkov [mailto:bp@alien8.de] 
发送时间: 2010年12月2日 21:17
收件人: Stanley Gan
抄送: 'LKML'
主题: Re: debug kernel using two laptops without serial port

On Thu, Dec 02, 2010 at 08:56:19PM +0800, Stanley Gan wrote:
> Hi All,
> 	I have two dell laptops 1015. For studying Linux kernel, I want to
> let one run debugging Linux as client, the other as host. The two laptops
> don't have serial port, just have LAN and usb ports. How can I configure
> them to get early kernel print message? I ever asked a lot of people, but
> don't get answers. Please give me some practical advices, thanks in advance.

Take a look at <Documentation/networking/netconsole.txt> in the kernel
sources.

-- 
Regards/Gruss,
Boris.

