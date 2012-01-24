Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2AXGiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 01:38:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63167 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2AXGiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 01:38:13 -0500
Date: Tue, 24 Jan 2012 00:38:02 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-bluetooth@vger.kernel.org
Cc: Andres Cimmarusti <acimmarusti@gmail.com>, linux-kernel@vger.kernel.org,
        info@linuxcertified.com, Paul Fertser <fercerpav@gmail.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: firmware loading failure for AR3011 (0cf3:3000 or 0cf3:3005 ?)
Message-ID: <20120124063802.GD30210@burratino>
References: <CAH=dYrHhttmRjkVuo9QvJ5_Uqd+BJGCJJkaMw8153RW1SFv9dA@mail.gmail.com>
 <20120124061430.GB30210@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124061430.GB30210@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder wrote:
> Andres Cimmarusti wrote:

>> [    9.335184] ath3k_load_firmware: Can't change to loading configuration err
>> [    9.335413] ath3k: probe of 1-1.3:1.0 failed with error -110
>
> Further investigation revealed that the problem seems to be in
> userspace: various kernels including a 2.6.32.y-based and 3.1.8-based
> one reproducibly exhibit this behavior with a Debian wheezy userspace
> and do _not_ exhibit the problem in Debian squeeze, Ubuntu 11.10, or
> Fedora 16.  More results:

Erm, I can't read.  Let's try that again:

 working userspace:	Debian squeeze, Ubuntu 11.04, Fedora 15
 broken userspace:	Debian wheezy, Ubuntu 11.10, Fedora 16

Sorry for the confusion.
