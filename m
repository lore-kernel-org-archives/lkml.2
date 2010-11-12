Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab0KLWCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:02:51 -0500
Received: from netrider.rowland.org ([192.131.102.5]:48661 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932938Ab0KLWCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:02:47 -0500
Date: Fri, 12 Nov 2010 17:02:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] OHCI: Fix for regression in 2.6.37-rc1 since commit
 3df7169e7
In-Reply-To: <AANLkTikgzdggq4HdBiS7M_6qs1vKbZRkbR70Y=m2JxVu@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1011121702001.22449-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010, [UTF-8] Pali Rohár wrote:

> Hello,
> 
> sorry for late. Can I test this patch (with usb shutdown patch) or is wrong?

It is wrong.  You can test it if you like, but it's not going to be 
accepted into the kernel.

Alan Stern

