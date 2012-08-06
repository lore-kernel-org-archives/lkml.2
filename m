Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2HFCoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:44:07 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46319 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2HFCoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:44:06 -0400
Subject: Re: [PATCH] Extcon: adc_jack: adc-jack driver to support 3.5 pi or
 simliar devices
From: anish kumar <anish198519851985@gmail.com>
To: myungjoo.ham@samsung.com
Cc: =?UTF-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        ANISH KUMAR <anish.singh@samsung.com>
In-Reply-To: <29824246.53241344219316571.JavaMail.weblogic@epml13>
References: <29824246.53241344219316571.JavaMail.weblogic@epml13>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Aug 2012 19:44:00 -0700
Message-ID: <1344221040.1516.0.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 02:15 +0000, 함명주 wrote:
> > From: anish kumar <anish198519851985@gmail.com>
> > 
> > External connector devices that decides connection information based on
> > ADC values may use adc-jack device driver. The user simply needs to
> > provide a table of adc range and connection states. Then, extcon
> > framework will automatically notify others.
> > 
> > Signed-off-by: anish kumar <anish.singh@samsung.com>
> 
> - Please remove "get_adc" callbacks still remaining in the header file
> (and its comments)
aha.Forgot to remove this.
> 
> - Let's not modify un-related driver code (in Kconfig, extcon-gpio)
I think this was unintended(my mistake).Sending the patch again.
> 
> Except that, things look good.
> 
> 
> Cheers
> MyungJoo
> 
> 


