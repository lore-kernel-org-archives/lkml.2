Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab0EZG4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:56:14 -0400
Received: from trinity.fluff.org ([89.16.178.74]:52276 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934124Ab0EZG4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:56:13 -0400
Date: Wed, 26 May 2010 07:56:11 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: kbuild: menuconfig with O=<dir> creates empty include/config in
	base
Message-ID: <20100526065611.GD4720@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing "make O=test menuconfig" the base kernel directory picks up
a new empty directory include/config which stops further "make O=temp"
builds as the make system thinks the base directory is not clean.

I've had a look, but it is not easy to see where this is hapening.

So far only menuconfig seems to have triggered it, xconfig seems to work.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

