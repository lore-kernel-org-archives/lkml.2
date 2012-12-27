Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab2L0I24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 03:28:56 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36301 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2L0I2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 03:28:54 -0500
Date: Thu, 27 Dec 2012 16:27:24 +0800
From: Woody Wu <narkewoody@gmail.com>
To: kernelnewbies@kernelnewbies.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: What does ISA/PCI really mean to ARM architecture?
Message-ID: <20121227082724.GA11775@zuhnb712.ap.bm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, list

I know this might be a very basic question.  But I really don't clear at
it.

Can a peripheral chip that claims to be ISA or PCI device be used in a
ARM based embedded system?  For these kind of chips, I only concern
about the planar kind of devices, means they are not on a dedicated
expansion card.

>From hardware point of view, to attach a ISA or PCI planar chip, is
there any requirement need to fulfill on a ARM bard?

>From Linux driver point of view, what are needed to support an ISA or
PCI driver in ARM architecture?  More important, is ISA or PCI device a
platform device?  If not, how to add these kind of devices in my board
definition?

I know my question might not be reasonable enough, if I messed concepts,
please sort me out.


Thanks in advance.


-- 
woody
I can't go back to yesterday - because I was a different person then.
