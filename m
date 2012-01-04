Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab2ADQVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:21:17 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63869 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2ADQVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:21:16 -0500
Date: Wed, 04 Jan 2012 08:21:11 -0800
From: Andrew Burgess <aab@cichlid.com>
Subject: Re: 3.1.5: uvcvideo: Failed to resubmit video URB (-27).
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-uvc-devel@lists.berlios.de
In-Reply-To: <CAO9zADw7ofMLeE3yCQ+uCe=6EzZY=SWtqMDhsi_ggbPhWVfTKg@mail.gmail.com>
	(from jpiszcz@lucidpixels.com on Tue Jan  3 06:21:02 2012)
X-Mailer: Balsa 2.4.10
Message-Id: <1325694071.16950.49@hogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2012 06:21:02 AM, Justin Piszcz wrote:

> It seems motion locks up every day or so and I see this in the kernel  
> logs:
> [378982.724053] uvcvideo: Failed to resubmit video URB (-27).
> [378982.724066] uvcvideo: Failed to resubmit video URB (-27).
> [378982.724079] uvcvideo: Failed to resubmit video URB (-27).
> [378982.724090] uvcvideo: Failed to resubmit video URB (-27).
> [378982.724101] uvcvideo: Failed to resubmit video URB (-27).

it sounds like a bug recently tracked down on the usb devel list
(search for 'Failed to resubmit video URB')

it turned out to be a bug in the usb host controller; if you
do an lspci do you see anything made by NetMos or MosChip?

mine says:

0b:00.0 USB Controller: NetMos Technology MCS9990 PCIe to 4‐Port USB  
2.0 Host Controller

mine is a pcie card; perhaps you have one built in?

hth
