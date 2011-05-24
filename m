Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab1EXOTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:19:37 -0400
Received: from xes-mad.com ([216.165.139.218]:5763 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471Ab1EXOTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:19:35 -0400
Subject: Re: [PATCH v6] gpio: Add support for Intel ICHx/3100/Series[56]
 GPIO
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Syed S Azam <Syed.Azam@hp.com>,
        Vincent Palatin <vpalatin@chromium.org>
In-Reply-To: <1303317354-18188-1-git-send-email-ptyser@xes-inc.com>
References: <1299022100-14564-4-git-send-email-ptyser@xes-inc.com>
	 <1303317354-18188-1-git-send-email-ptyser@xes-inc.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 09:18:57 -0500
Message-ID: <1306246737.22090.2233.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 11:35 -0500, Peter Tyser wrote:
> This driver works on many Intel chipsets, including the ICH6, ICH7,
> ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> (Cougar Point), and NM10 (Tiger Point).
> 
> Additional Intel chipsets should be easily supported if needed, eg the
> ICH1-5, EP80579, etc.
> 
> Tested on a QM57 (Ibex Peak), 3100 (Whitmore Lake) , and
> NM10 (Tiger Point).
> 
> Cc: Alek Du <alek.du@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Syed S Azam <Syed.Azam@hp.com>
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> Tested-by: Vincent Palatin <vpalatin@chromium.org>

Ping...


