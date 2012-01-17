Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2AQRKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:10:09 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34964 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755110Ab2AQRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:10:07 -0500
X-Sasl-enc: ijFVRkWO6j0v2SjbXF61Avt8f9rvgR6uEifLoIoRkHpa 1326820206
Date: Tue, 17 Jan 2012 09:09:53 -0800
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [29/48] HID: wiimote: Select INPUT_FF_MEMLESS
Message-ID: <20120117170953.GA21074@kroah.com>
References: <20120116184527.GA11972@kroah.com>
 <20120116184518.205969311@clark.kroah.org>
 <CAP=VYLqajuhNY1S3e7Nbw4DiyEDL1uGthC8VswJ9zJxzwy+wOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP=VYLqajuhNY1S3e7Nbw4DiyEDL1uGthC8VswJ9zJxzwy+wOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 08:55:59PM -0500, Paul Gortmaker wrote:
> On Mon, Jan 16, 2012 at 1:44 PM, Greg KH <gregkh@suse.de> wrote:
> > 3.1-stable review patch.  If anyone has any objections, please let me know.
> 
> This one looks like typical patch Makefile/Kconfig "oh, hey this fits anywhere"
> nonsense, and is completely broken.  Original was for a Wiimote, not Wacom.

Ah, thanks for catching that, I missed it on the fuzz application.  I've
removed it now from this tree, and the 3.0 tree.

greg k-h
