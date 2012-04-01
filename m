Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab2DALnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 07:43:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61287 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2DALnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 07:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120330195726.845212875@linuxfoundation.org>
References: <20120330195812.GA31833@kroah.com>
	<20120330195726.845212875@linuxfoundation.org>
Date: Sun, 1 Apr 2012 13:43:18 +0200
Message-ID: <CACRpkda-feATvkKnSb68PDkQrvqNnbsVSG=naxtdW7FHdRUX2A@mail.gmail.com>
Subject: Re: [ 033/108] serial: PL011: clear pending interrupts
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Chanho Min <chanho0207@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jong-Sung Kim <neidhard.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 9:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:

> 3.0-stable review patch.  If anyone has any objections, please let me know.

Objections: do not add this to the stable series unless the currently
under-review patch "serial: PL011: move interrupt clearing" is
also included.

Together they solve a real problem, but alone this causes a new
problem.

Yours,
Linus Walleij
