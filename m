Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0H3IbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:31:10 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:37440 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751124Ab0H3IbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:31:08 -0400
Date: Mon, 30 Aug 2010 10:31:05 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alexander Kurz <linux@kbdbabel.org>,
        Andrea Gelmini <andrea.gelmini@gelma.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] pcmcia: comedi: fix compile error
Message-ID: <20100830083105.GA1295@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	Alexander Kurz <linux@kbdbabel.org>,
	Andrea Gelmini <andrea.gelmini@gelma.net>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100830081231.GL9832@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100830081231.GL9832@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

On Mon, Aug 30, 2010 at 10:14:45AM +0200, Dan Carpenter wrote:
> We changed struct pcmcia_device in 90abdc3b973229 "pcmcia: do not use
> io_req_t when calling pcmcia_request_io()".  The rest of this file got
> updated to the new API but this line was missed so my config doesn't
> compile.

a similar patch is already in my queue -- will send it to Linus for -rc4...

Thanks,
	Dominik
