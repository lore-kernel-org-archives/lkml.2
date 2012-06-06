Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2FFSuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:50:03 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:57454 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2FFSuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:50:02 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 14:50:02 EDT
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] fix usb skeleton driver
Date: Wed, 6 Jun 2012 20:37:53 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Ming Lei <tom.leiming@gmail.com>, stefani@seibold.net,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1206061104390.1788-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1206061104390.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206062037.53418.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Juni 2012, 17:06:59 schrieb Alan Stern:
> On Wed, 6 Jun 2012, Ming Lei wrote:

> > So many purposes, you need to split your patches for review easily, :-)
> 
> Not just that...  usb-skeleton is intended to be a good example, to
> help people learn how to write USB drivers.  It's already far too
> complicated for this purpose, and adding more complication will just
> make it worse.
> 
> Instead of adding things to usb-skeleton, we should take things away.

Not really. The features in the driver make sense. Probably we should
have two versions. One simple and basic and the other showing advanced
techniques. And a lot more comments.

	Regards
		Oliver
