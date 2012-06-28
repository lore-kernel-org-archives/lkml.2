Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2F1Njr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:39:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35992 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2F1Njp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:39:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120628131651.GA14492@gherkin.frus.com>
References: <20120628131651.GA14492@gherkin.frus.com>
Date: Thu, 28 Jun 2012 21:39:45 +0800
Message-ID: <CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com>
Subject: Re: 3.5-rcX: USB support without udev?
From: Ming Lei <tom.leiming@gmail.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 9:16 PM, Bob Tracy <rct@gherkin.frus.com> wrote:
> With the removal of the deprecated usbfs feature in the 3.5 release
> candidates, is there a way of getting USB devices working on a non-
> embedded Linux system without udev (static "/dev")?

Please try to enable below options:

CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y

and you need not the static dev nodes with devtmpfs.



Thanks,
-- 
Ming Lei
