Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0IMVSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:18:09 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33996 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0IMVSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B/GTGINYosZoFdrUa9vYZSGpzX1wWP23PaFi2WLl774rgFDjXhqm/KB2j95ye+18Op
         9ZOfzhL+1t0jWEqys44e74x7lApwC2a7H6zlJyfXF0cORN4LE4uDkPJ279MfCI9eO7RC
         fGzRxZ11dCaIEOzuMbQbM7lNlKuVfI2wsPiSc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikQsu4qo=nkcr2N=_GLmtCgh8wmoRcZFaUJbwAs@mail.gmail.com>
References: <1284319955-6014-1-git-send-email-guichaz@gmail.com>
	<201009131325.01768.arnd@arndb.de>
	<alpine.LNX.2.00.1009131327060.26813@pobox.suse.cz>
	<AANLkTikQsu4qo=nkcr2N=_GLmtCgh8wmoRcZFaUJbwAs@mail.gmail.com>
Date: Mon, 13 Sep 2010 23:18:06 +0200
Message-ID: <AANLkTinvTQa8BPeT8shAB4Qt3eyepYeyG29oCugXzgw6@mail.gmail.com>
Subject: Re: [PATCH] Fix hiddev's use of usb_find_interface
From: Guillaume Chazarain <guichaz@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 1:38 PM, Guillaume Chazarain <guichaz@gmail.com> wrote:
> I also saw the problem with 2.6.36-rc3.

For completeness, I also reproduced the problem with 2.6.36-rc4. Not
being familiar with the driver model, I'm not attached to the approach
I took in the patch, but it solves a real regression: hiddev not
working.

-- 
Guillaume
