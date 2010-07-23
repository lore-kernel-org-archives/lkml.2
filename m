Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab0GWUTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:19:30 -0400
Received: from gherkin.frus.com ([192.158.254.49]:38781 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114Ab0GWUT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:19:28 -0400
Date: Fri, 23 Jul 2010 15:19:27 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: linux-net@vger.kernel.org
Subject: Re: [BUG] dm9601 driver won't init device properly
Message-ID: <20100723201927.GA4414@gherkin.frus.com>
References: <20100723195736.GA4321@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723195736.GA4321@gherkin.frus.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 02:57:36PM -0500, Bob Tracy wrote:
> (...)
> Jul 23 13:57:26 no1nozit kernel: [ 1182.910095] eth2: register 'dm9601' at usb-0000:00:1d.0-2, Davicom DM9601 USB Ethernet, 04:00:06:04:06:e0
> (...)
> ... the reported MAC address may not be correct -- I need to check
> against the value reported for WinXP...

As suspected, the Linux driver is reporting a bogus value.  The correct
MAC address is 00:06:06:e0:00:1a.  Perhaps this is a useful clue as to
what's going on.

--Bob
