Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0KOGML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:12:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab0KOGMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:12:10 -0500
Date: Sun, 14 Nov 2010 23:12:26 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, zaitcev@redhat.com
Subject: Re: [PATCH, RFC] usbmon: correct computing of the ISO packets with
 mmap
Message-ID: <20101114231226.16782336@lembas.zaitcev.lan>
In-Reply-To: <4CE0C9B8.1010403@freemail.hu>
References: <4CD8ECE4.1090206@freemail.hu>
	<20101109075056.59a2e7d8@lembas.zaitcev.lan>
	<4CD9A96D.1010306@freemail.hu>
	<4CDF0DF4.4020405@freemail.hu>
	<20101114124035.6a0c9b80@lembas.zaitcev.lan>
	<4CE0458E.9070900@freemail.hu>
	<20101114162502.6d6318e7@lembas.zaitcev.lan>
	<4CE0C9B8.1010403@freemail.hu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 06:48:40 +0100
Németh Márton <nm127@freemail.hu> wrote:

> ev_type == 'S' && usb_urb_dir_out(urb)  ---> data is available, we'll need it

The write submission case should be covered by the transfer_buffer_length,
I think. Is there a driver that only sets the ISO descriptors but not
the overall length?

-- Pete
