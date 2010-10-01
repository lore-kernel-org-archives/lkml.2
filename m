Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0JAJCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:02:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:37322 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0JAJCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:02:44 -0400
Subject: Re: Introduce support for little endian PowerPC
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Date: Fri, 1 Oct 2010 04:02:24 -0500
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
To: Ian Munsie <imunsie@au1.ibm.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2010, at 2:05 AM, Ian Munsie wrote:

> Some PowerPC processors can be run in either big or little endian modes, some
> others can map selected pages of memory as little endian, which allows the same
> thing. Until now we have only supported the default big endian mode in Linux.
> This patch set introduces little endian support for the 44x family of PowerPC
> processors.

>From a community aspect is anyone actually going to use this?  Is this going to be the equivalent of voyager on x86?  I've got nothing against some of the endian clean ups this introduces.  However the changes to misc_32.S are a bit ugly from a readability point of view.  Just seems like this is likely to bit-rot pretty quickly.

- k

