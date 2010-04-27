Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0D0MUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:20:10 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37956 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0D0MUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gnKwo+FOYxBUarOwyk72WRwvWCm6cqZQPydyAUWWrS5eKojbvoQnbq+QqHLHlOz4vd
         5e0gc94C6ct8GTgN4SMMIo/2ob6h9DtOAeSMWuQMQYZPIhLKhBJY9EqwZzCRGe23EAv7
         itY4IqkwJogIrI+e/QzN9YfITCvrhiuZ0z0EA=
MIME-Version: 1.0
In-Reply-To: <1272278094-25433-1-git-send-email-fabien.chouteau@gmail.com>
References: <1272278094-25433-1-git-send-email-fabien.chouteau@gmail.com>
Date: Tue, 27 Apr 2010 14:19:42 +0200
Message-ID: <u2tfb5cec441004270519s5aa901c0ib08a63f2be4f0af2@mail.gmail.com>
Subject: Re: [PATCH RE-RESEND] Mass storage gadget: Handle eject request
From: Chouteau Fabien <fabien.chouteau@gmail.com>
To: linux-usb@vger.kernel.org
Cc: Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 12:34 PM, <fabien.chouteau@gmail.com> wrote:
>
> From: Fabien Chouteau <fabien.chouteau@barco.com>
>
> This patch adds handling of the "Start/Stop Unit" SCSI request
> to simulate media ejection.

Any comments on the last version?



--
Fabien Chouteau
EPITA GISTR 2010
