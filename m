Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0JYLUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:20:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50875 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0JYLUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T27/5PtBpaL16haeJ/OiI/kfOU5bYWITWxsaYXK8ndccTWZOw9+yvZlFSCJ6RuISML
         7dgJ69GeefqrbaLks3oWYFyoWMmulaH7Zgyaw2TR7hfd53GNM4gz6dkKZ5iJm9/YcaXO
         vWyMWelUk8EZgr0vuoHuXB1d6xDGO1Hu2xhew=
Date: Mon, 25 Oct 2010 13:20:43 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alon Ziv <alon+git@nolaviz.org>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Export usb_serial_generic_write_room for use in
 modules
Message-ID: <20101025112043.GB4046@localhost>
References: <1287859409-13810-1-git-send-email-alon-git@nolaviz.org>
 <1287859409-13810-2-git-send-email-alon-git@nolaviz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287859409-13810-2-git-send-email-alon-git@nolaviz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 08:43:28PM +0200, Alon Ziv wrote:
> Any module using usb_serial_generic_write (which is already exported)
> had better use usb_serial_generic_write_room as well, or be prepared
> for failures.

As I mentioned elsewhere, this description is a little misleading as any
driver can use the generic write_room implementation simply by not
overriding it (i.e. leaving the write_room field undefined).

There is nothing wrong with exporting it, but it is currently only your
other patch that requires that. Could you perhaps just modify the patch
description?

Thanks,
Johan
