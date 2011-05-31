Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1EaKrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:47:05 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:34652 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab1EaKrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:47:03 -0400
Date: Tue, 31 May 2011 12:47:02 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq@rere.qmqm.pl>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH v4] 8250_pci: add -ENODEV code for Intel EG20T PCH
Message-ID: <20110531104702.GA15469@rere.qmqm.pl>
References: <1306838130-3644-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1306838130-3644-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 07:35:30PM +0900, Tomoya MORINAGA wrote:
> Intel EG20T PCH has UART device which is compatible with 8250.
> Currently, with general configuration, the PCH UART driver is not loaded but
> 8250 standard driver is loaded.
> Therefore, in case of using PCH UART driver, need to disable 8250 pci function.
> However, this procedure is not best solution.
> This patch, in 8250_pci, if the device is the PCH or the family IOH,
> '-ENODEV' is returned.
> As a result, disabling 8250-pci processing becomes unnecessary.
[...]

My comment about return_ENODEV() name does not make sense if you put the
ifdef inside that function. I thought you would put it around the device-id
entries.

Best Regards,
Micha³ Miros³aw
