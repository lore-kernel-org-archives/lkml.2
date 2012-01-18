Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2ARCmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:42:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48228 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab2ARCmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:42:17 -0500
MIME-Version: 1.0
In-Reply-To: <1326726380.1540.112.camel@vkoul-udesk3>
References: <1326726380.1540.112.camel@vkoul-udesk3>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jan 2012 18:41:55 -0800
X-Google-Sender-Auth: VIyexTi8d8kPsX_soDws9WEwrPg
Message-ID: <CA+55aFyR7hKoeffHY6VYw-29pii+NVgsH2aFKU3YfW1-kFUtMg@mail.gmail.com>
Subject: Re: [GIT PULL] slave-dmaengine updates
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 7:06 AM, Vinod Koul <vinod.koul@intel.com> wrote:
>
> Here is the slave-dmaengine updates which include a new DMA engine API
> for 2D interleaved transfers along with fixes for slave dma_tranfer
> direction along with usual fixes and updates on bunch of the slave dma
> drivers.

Ok, please verify my conflict resolution. It all looked pretty
trivial, but affected code that I don't know nor can I even
test-compile.

               Linus
