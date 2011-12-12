Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1LLPzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:55:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43450 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1LLPzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:55:08 -0500
MIME-Version: 1.0
In-Reply-To: <1323701322.1806.24.camel@wwguy-ubuntu>
References: <j881g5$tdf$1@dough.gmane.org> <alpine.DEB.2.00.1110252325090.20273@chino.kir.corp.google.com>
 <j8fvka$fu0$1@dough.gmane.org> <CA+tb8OUHNbhVN_KiEkqXJW1apFoExRM5Vrn=ES5SF3sFoGOMfA@mail.gmail.com>
 <1323701322.1806.24.camel@wwguy-ubuntu>
From: =?UTF-8?Q?Mat=C3=ADas_Aguirre?= <matiasaguirre@gmail.com>
Date: Mon, 12 Dec 2011 13:49:25 -0200
Message-ID: <CA+tb8OX9+xn=G6i+ncQjGMd4MvnjHh1t3ZbuX6Ki1eZCjNhj4A@mail.gmail.com>
Subject: Re: wifi iwlagn fails to authenticate after wake from suspend
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Gene Smith <gds@chartertn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 12:48 PM, wwguy <wey-yi.w.guy@intel.com> wrote:
> this is not right, you stop the bt coex for non-combo device.
> maybe you system has issue with BT, we seen this happen on some cases.
> try the following module parameter and see if help
>
> $sudo modprobe iwlagn bt_coex_active=0

bt_coex_active=0 fixed this issue, thanks Wey


-- 
Matías Aguirre
