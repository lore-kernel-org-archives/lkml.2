Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0F1U7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:59:51 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:41125 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0F1U7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:59:50 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Przemo Firszt <przemo@firszt.eu>
Subject: Re: [PATCH] Expose vendor-specific ACM channel on Nokia 5230
Date: Mon, 28 Jun 2010 22:59:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-9-desktop; KDE/4.4.3; x86_64; ; )
Cc: oliver@neukum.name, gregkh@suse.de, alan@linux.intel.com,
       francescolavra@interfree.it, julian.calaby@gmail.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1277756974-3373-1-git-send-email-przemo@firszt.eu>
In-Reply-To: <1277756974-3373-1-git-send-email-przemo@firszt.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006282259.11598.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 28. Juni 2010, 22:29:34 schrieb Przemo Firszt:
> Nokia S60 phones expose two ACM channels. The first is
> a modem, the second is 'vendor-specific' but is treated
> as a serial device at the S60 end, so we want to expose
> it on Linux too.
> 

I see. We want to expose it. But do we want to expose it as an acm interface?

	Regards
		Oliver
