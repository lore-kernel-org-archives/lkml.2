Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2FUQEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:04:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34887 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab2FUQEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:04:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120621134942.GA8401@kroah.com>
References: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
	<20120615220343.GA8928@kroah.com>
	<CACVXFVO6h6wiHdTwVcjQLNtncO+ezVX3RJZPVenHEmhHjErRhg@mail.gmail.com>
	<20120618222550.GB11737@kroah.com>
	<CACVXFVOr1mnjaEoGpc3O_MDuvi_KHTXtsEBQ7LLoaeWxWRa0aQ@mail.gmail.com>
	<20120620223754.GA5864@kroah.com>
	<CACVXFVNP4HJwtjgAD=D7Fv7NW2j1aHj55X8j-4qhpBZTcw2+7w@mail.gmail.com>
	<20120621134942.GA8401@kroah.com>
Date: Fri, 22 Jun 2012 00:04:21 +0800
Message-ID: <CACVXFVM=p3_rqsRF0BWdZ30GW5zgDgy6jbfqNP6xwHJoOQx1Wg@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 9:49 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> We also have not made the rule that a shutdown will complete in a
> specific amount of time either, so there is no problem if that takes a
> long time as well.

OK, I will submit a new patch which just holds device lock.

Alan, do you have objections on the new one?

Thanks,
--
Ming Lei
