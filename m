Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0HPK5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 06:57:30 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47009 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab0HPK53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 06:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vWW5PK4YktJylh4zXbZJYFaiLeF2q/KAabufwbFTnJxlzCzjEuXDTWxIuTa0OWgHcF
         jia0choHGl3m2qIEyqNx2n0Kl81HWaEDx8BhKUayPbSSSzcGsLh0bm5dADye8Bzh4r+m
         qxI2PF+4hFdbJfOX55i2TtQdKkDu69SXILbSM=
MIME-Version: 1.0
In-Reply-To: <20100809160819.42e8c84e@lxorguk.ukuu.org.uk>
References: <1281363770-23598-1-git-send-email-dbaryshkov@gmail.com>
	<20100809160819.42e8c84e@lxorguk.ukuu.org.uk>
Date: Mon, 16 Aug 2010 14:57:28 +0400
Message-ID: <AANLkTinRVuP7GWo8mrGTy_DR1gv=od5-FQEEb4KO_YWo@mail.gmail.com>
Subject: Re: [PATCH 1/2] tty: add tty_struct->dev pointer to corresponding
 device instance
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 9, 2010 at 7:08 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon,  9 Aug 2010 18:22:49 +0400
> Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:
>
>> Some device drivers (mostly tty line disciplines) would like to have way
>> know a struct device instance corresponding to passed tty_struct. Add
>> a struct device pointer to struct tty_struct and populate it during
>> initialize_tty_struct().
>
> Acked-by: Alan Cox <alan@linux.intel.com>
>

Greg, what about these two patches? Can I expect for them to be pulled
into your patch queue for 2.6.37?

-- 
With best wishes
Dmitry
