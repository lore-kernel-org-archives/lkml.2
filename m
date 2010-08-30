Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0H3Mes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:34:48 -0400
Received: from relay.atmel.no ([80.232.32.139]:52368 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab0H3Mer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:34:47 -0400
Date: Mon, 30 Aug 2010 14:34:23 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC PATCH 10/43] ptrace, avr32: cleanup arch_ptrace()
Message-ID: <20100830143423.07c54c35@hskinnemoen-d830>
In-Reply-To: <1282902149-12991-11-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
	<1282902149-12991-11-git-send-email-namhyung@gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> wrote:
> use new 'datap' variable type of void pointer in order to remove unnecessary
> castings.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
