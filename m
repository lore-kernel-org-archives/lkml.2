Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab1FPE4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:56:23 -0400
Received: from gherkin.frus.com ([192.158.254.49]:32928 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab1FPE4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:56:22 -0400
Date: Wed, 15 Jun 2011 23:56:21 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 3.0.0-rc2 usb mouse not working
Message-ID: <20110616045620.GA5651@gherkin.frus.com>
References: <20110615032318.GA2575@gherkin.frus.com> <20110615131544.GA3074@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615131544.GA3074@gherkin.frus.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 08:15:44AM -0500, Bob Tracy wrote:
> On Tue, Jun 14, 2011 at 10:23:18PM -0500, Bob Tracy wrote:
> > Note: 3.0.0-rc1 hung during boot (right after parport initialization),
> > so the best I can do at the moment is say the bug first showed up after
> > 2.6.39.  Processor is an AMD K6-III/450.
> > 
> > Symptoms: Microsoft Intellimouse (corded USB optical) non-functional.
> > 	Red LED comes on when mouse is plugged in, but movement and
> > 	clicks are not seen.

To make a long story short, the required "usbhid" module is not being
loaded automatically in 3.0-rcX as it was in 2.6.39 and earlier kernels.
A simple "modprobe usbhid" got the mouse working again.

--Bob
