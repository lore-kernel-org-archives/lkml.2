Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0CSWkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:40:40 -0400
Received: from www84.your-server.de ([213.133.104.84]:47885 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab0CSWkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:40:15 -0400
Subject: Re: include/linux/kfifo.h - INIT_KFIFO() broken?
From: Stefani Seibold <stefani@seibold.net>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20100319221740.GA26455@hardeman.nu>
References: <20100319221740.GA26455@hardeman.nu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 19 Mar 2010 23:40:38 +0100
Message-ID: <1269038438.30679.0.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 19.03.2010, 23:17 +0100 schrieb David Härdeman:
> The current include/linux/kfifo.h header defines __kfifo_initializer at
> line 59 and undefines it at line 105. INIT_KFIFO() uses
> __kfifo_initializer so INIT_KFIFO is currently not usable unless
> line 105 is removed (if I have analysed the problem correctly).
> 
> The updated kfifo patchset by Stefani Seibold seems to fix that 
> particular problem, but if it isn't included in 2.6.34, then at least 
> INIT_KFIFO should be fixed (and that goes for 2.6.33.X as well).
> 

Please send a patch


