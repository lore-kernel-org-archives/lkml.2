Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2HPRkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:40:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61066 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2HPRkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:40:23 -0400
Date: Thu, 16 Aug 2012 10:40:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: anish kumar <anish198519851985@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        anish kumar <anish.singh@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] [PATCH V6]Extcon: adc_jack: adc-jack driver to support
 3.5 pi or simliar devices
Message-ID: <20120816174019.GA10918@kroah.com>
References: <1344583783-12593-1-git-send-email-anish198519851985@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344583783-12593-1-git-send-email-anish198519851985@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 12:29:43AM -0700, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> External connector devices that decides connection information based on
> ADC values may use adc-jack device driver. The user simply needs to
> provide a table of adc range and connection states. Then, extcon
> framework will automatically notify others.

This patch breaks the build:
	ERROR: "extcon_cable_name" [drivers/extcon/extcon-adc-jack.ko] undefined!

And, if you read the comment about extcon_cable_name, it says to not use
it like you are trying to use it.

So, care to fix this up?

thanks,

greg k-h
