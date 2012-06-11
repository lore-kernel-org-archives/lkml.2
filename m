Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2FKORq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:17:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50482 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754971Ab2FKORo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:17:44 -0400
Date: Mon, 11 Jun 2012 10:17:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Namjae Jeon <linkinjeon@gmail.com>
cc: James.Bottomley@HansenPartnership.com, <gregkh@linuxfoundation.org>,
        <mdharm-usb@one-eyed-alien.net>, <sshtylyov@mvista.com>,
        <bvanassche@acm.org>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v4 2/3] usb: storage: add support for write cache quirk
 on
In-Reply-To: <1339421599-3173-1-git-send-email-linkinjeon@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206111017260.1607-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, Namjae Jeon wrote:

> Add support for write cache quirk on usb hdd. scsi driver will be set to wce by detecting write cache quirk in quirk list when plugging usb hdd.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

