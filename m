Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782Ab0FKJTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:19:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42300 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab0FKJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:19:07 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Lothar =?iso-8859-1?q?Wa=DFmann?= <LW@karo-electronics.de>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Date: Fri, 11 Jun 2010 17:18:44 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Ben Dooks <ben-linux@fluff.org>,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1275636608.606606.450179637764.0.gpush@pororo> <201006111557.12249.jeremy.kerr@canonical.com> <19473.61547.684572.647641@ipc1.ka-ro>
In-Reply-To: <19473.61547.684572.647641@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006111718.47426.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

> Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> makes it impossible to call those functions in interrupt context.

Do we do this at the moment? I know at least one implementation of clk_enable 
uses a mutex for locking.

Cheers,


Jeremy
