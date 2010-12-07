Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0LGXbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 18:31:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42324 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0LGXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 18:31:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ZqDsp0BQG7//pTeXRes+ngTgiD7SbZVjVeX5Sr2FlnYMrxcfjED9qInv4Nt1SOVu+d
         tPWZz5Off8dQMrF9/qgdwhFhpljjqkWNfnUkCbmRpYpvlI2k7qY5SEr86Q+iUyepHfr6
         12AxU03scaMXVCtktHUwcuNZMfadWyWeEe4go=
MIME-Version: 1.0
In-Reply-To: <1291630198-9690-2-git-send-email-s.hauer@pengutronix.de>
References: <1291630198-9690-1-git-send-email-s.hauer@pengutronix.de>
	<1291630198-9690-2-git-send-email-s.hauer@pengutronix.de>
Date: Tue, 7 Dec 2010 15:31:37 -0800
X-Google-Sender-Auth: gVEcGjIyRRFhQ9AEAwN8psr7jtk
Message-ID: <AANLkTikcCShzZLykX9YrrT3kbCOknDnAS0YMenytYgdG@mail.gmail.com>
Subject: Re: [PATCH 1/2] dmaengine i.MX SDMA: initialize on module_init
From: Dan Williams <dan.j.williams@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 2:09 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> The firmware framework gets initialized during fs_initcall time, so
> we are not allowed to call request_firmware earlier.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---

Applied.
