Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2JUHop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 03:44:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50319 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2JUHoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 03:44:44 -0400
Date: Sun, 21 Oct 2012 09:44:34 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: caiyuqing <yuqingcaik@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: question about context switch on arm Linux
Message-ID: <20121021074434.GB4735@netboy.at.omicron.at>
References: <50839002.8020305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50839002.8020305@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 02:02:42PM +0800, caiyuqing wrote:
> hi, all.
> I have some questions about context switch on arm Linux (my target is
> ARMv7-a).
> 1. Does arm linux support FCSE to handle the context switch?

No, mainline Linux does not support FCSE. However, you can use Gilles'
unoffical (but working) FCSE branches at

  http://git.xenomai.org/?p=ipipe-gch.git;a=summary

> 2. If using FCSE, that means the processes number limit is 128 and the
> memory limit is 32MB per process, is that right?

Yes and no.

Gilles' patches offer a "strict mode" and a "best effort" mode. The
strict mode does have the limitation, but the best effort mode does
not.

HTH,
Richard
