Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab2DTJhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:37:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56357 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2DTJhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:37:38 -0400
Date: Fri, 20 Apr 2012 17:37:38 +0800
From: Wang YanQing <udknight@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [RFC]Is usb port number fixed?
Message-ID: <20120420093738.GA12755@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <20120420092525.GA12660@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420092525.GA12660@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 05:25:25PM +0800, Wang YanQing wrote:
> Hi!
> when I execute the command below:
> 
> "ls /sys/bus/usb/devices/"
> 
> I get:
> "1-0:1.0 1-1 1-1:1.0 2-0:1.0 2-1 2-1.1 2-1:1.0 2-1.1:1.0 2-1.5 2-1.5:1.0 2-1.5:1.1  usb1  usb2"
> 
> the output format is bus-port.port:config.interface
> I want to know whether the port number is fixed after I reboot machine time by time.
> And if it is fixed, then what make it.
> 
> Thanks!

Make the question precise.
I assme there are two usb ports in my notebook at left and right separately.
When I plug mouse into 
left usb port, I get 2-1.1:1.0
right usb port, I get 2-1.2:1.0

I want to know whether it is right that no matter how many times I reboot the machine,
the test result above will be the same.And if it will be the same, then why it will be the same.


