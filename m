Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2E1Tbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 15:31:41 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:49829 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab2E1Tbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 15:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
References: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
Date: Mon, 28 May 2012 21:31:39 +0200
Message-ID: <CAFLxGvzBytBgeYVFNYKbZdeaH_fFGrDpNC_zJw5+kFKEv4hOPw@mail.gmail.com>
Subject: Re: [PATCH] staging: comedi: cb_pcidas64: Fixed coding style errors
 and an if-statement
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 8:28 PM, Dimitrios Semitsoglou-Tsiapos
<dimitrios.semitsoglou@gmail.com> wrote:
> Fixed a few coding style errors and an if-statement responsible for a
> sanity check inside the prep_ao_dma function.

Please submit two patches for this.
Don't mix coding style and logic fixes.

-- 
Thanks,
//richard
