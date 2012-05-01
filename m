Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2EAQA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:00:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56109 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab2EAQAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:00:21 -0400
Date: Tue, 1 May 2012 13:00:14 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bluetooth@vger.kernel.org
Subject: Re: Weird bluetooth keyboard regression - just me?
Message-ID: <20120501160014.GB1419@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
References: <20120501073711.028d31d6@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501073711.028d31d6@lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

* Jonathan Corbet <corbet@lwn.net> [2012-05-01 07:37:11 -0600]:

> Life has not been conducive to frivolities like trying new kernels, but I
> finally gave 3.4-rc5 a go yesterday.  I'm seeing some decidedly weird
> keyboard behavior; it seems surprising that nobody else has complained.
> 
> I have a logitech Dinovo Edge bluetooth keyboard that I've used for
> years.  With 3.4 kernels, the keyboard generates no input until I've
> banged on it for a couple of seconds.  If I continually hit characters,
> they make it through; as soon as I stop for even a brief period (even
> somebody as verbose as me has to come up for air occasionally), it goes
> back to sleep.

This looks weird, I suspect of something. Could you try running
'bluetoothd -nd -P mgmtops' and check if the problem still happens too
you?

	Gustavo
