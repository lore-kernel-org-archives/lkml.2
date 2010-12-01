Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab0LAUdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:33:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59572 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab0LAUdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=co3buntEaqtb/xb01/rLuFPewt26ACwibxWcU2ZHl03GOjE2KKzLaPwQgVhX6GVr03
         jTaU6suy9em19XZNfjEXosanf93i7yJitV/55ysdhbE9fzCu86EjAG8Pa0X0exSsJVE/
         AQwpDrJmIT6vvE1jejC6+/MtTO1wo/c1wT4Yk=
MIME-Version: 1.0
In-Reply-To: <20101201193712.GA918@suse.de>
References: <1291225529-1118-1-git-send-email-namhyung@gmail.com> <20101201193712.GA918@suse.de>
From: Namhyung Kim <namhyung@gmail.com>
Date: Thu, 2 Dec 2010 05:32:49 +0900
Message-ID: <AANLkTimn6515BwQooTfHyLq48QXHpAkaOcxfDb5FmbkG@mail.gmail.com>
Subject: Re: [PATCH 1/3] USB: whci-hcd: move whci_hcd_id_table under #ifdef MODULE
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 04:37, Greg KH <gregkh@suse.de> wrote:
> Ick, no, please just use the __used type instead.  We don't want #ifdefs
> in .c files if at all possible.
>
> Same goes for the other 2 patches, care to redo them as well?
>

OK. Will send them again.

-- 
Regards,
Namhyung Kim
