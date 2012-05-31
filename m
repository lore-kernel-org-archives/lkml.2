Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2EaRzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:55:22 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:33185 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2EaRzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:55:21 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 13:55:20 EDT
From: Krystian Garbaciak <Krystian.Garbaciak@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: RE: [PATCH 1/4] regmap: Reorganise internal read/write functions.
Thread-Topic: [PATCH 1/4] regmap: Reorganise internal read/write functions.
Thread-Index: AQHNP0xIKdPWOgFao0qokmR3zvGRkpbkLP0g
Date: Thu, 31 May 2012 17:53:16 +0000
Message-ID: <751C305CD2876B4990194D0512DE8BF2441CA8CA@SW-EX-MBX01.diasemi.com>
References: <201205311607.q4VG7avr012901@sw-eng-lt-dc-vm2>
 <20120531164148.GK2666@opensource.wolfsonmicro.com>
In-Reply-To: <20120531164148.GK2666@opensource.wolfsonmicro.com>
Accept-Language: pl-PL, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, May 31, 2012 at 04:11:12PM +0200, Krystian Garbaciak wrote:
> 
> > +static int _regmap_raw_write(struct regmap *map, unsigned int reg,
> > +			     const void *val, size_t val_len) {
> > +	void *_val = (void *)val;
> 
> This is scary...  why are we casting away const here?

I will remove it from here.
However, on next patch I need to pass *val for reading and writing to the same function. I will put casting there and comment it.

Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.

Please consider the environment before printing this e-mail
