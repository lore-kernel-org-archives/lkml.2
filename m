Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2FLBC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:02:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab2FLBCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:02:54 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206111202010.1607-100000@iolanthe.rowland.org>
References: <CACVXFVNS2U-t7_8WwVNhQprP29y_xiZX25WwoBD5SRpch-p+7A@mail.gmail.com>
	<Pine.LNX.4.44L0.1206111202010.1607-100000@iolanthe.rowland.org>
Date: Tue, 12 Jun 2012 09:02:51 +0800
Message-ID: <CACVXFVPEwZk09+jsStZcf_4qeK-NPXZUVuvrkj17k2zu0b6JBQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 12:02 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 11 Jun 2012, Ming Lei wrote:
>>
>> I have considered doing it, but which may consume another 1sec.
>>
>> Also if the parent lock has been held, it is very possibly that the
>> device can't be probed or removed at the same time, so just logged
>> the crazy thing and go ahead.
>
> Okay.  Then you can add my Acked-by.

Thanks, I think Greg will do it.


Thanks,
--
Ming Lei
