Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1ISO0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:26:51 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45825 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164Ab1ISO0u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAH+eYFBSiL44CMOpgED+TAOTUH_dQMaKKu=hC3ynG0Y2nQ8ekw@mail.gmail.com>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
	<CAH+eYFBSiL44CMOpgED+TAOTUH_dQMaKKu=hC3ynG0Y2nQ8ekw@mail.gmail.com>
Date: Mon, 19 Sep 2011 09:26:49 -0500
Message-ID: <CAB-zwWi1K8y8fHzy0hgcFPgSfhMrZNfoKQ9xuU00Y1sLg6ZBmw@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Rabin Vincent <rabin@rab.in>, Russell King <linux@arm.linux.org.uk>
Cc: lak <linux-arm-kernel@lists.infradead.org>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Sep 17, 2011 at 1:07 AM, Rabin Vincent <rabin@rab.in> wrote:
> If the "Use generic BUG() handler" patch is only scheduled for the next
> merge window and not for 3.1, can this patch be merged instead for 3.1
> and -stable?  This problem is easily seen with GCC 4.6.

I can send it for both and let the maintainers decide.

Russell, do you give your ack?

Regards,

Omar
