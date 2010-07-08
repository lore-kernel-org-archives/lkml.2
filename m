Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0GHUV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:21:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33254 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab0GHUV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=yGQIntNtiMGpEjEpCeQS1SMz1X8LrFj88BMbInTmiqRpYQ93mv8hlk7DX4zfG6ikTs
         DVk+2exRHZrC2E432FbOd5mG37ZD+ITNOmJasfo/E5QY5PJEd+w0Zli6Tc0jK8/Y9z+k
         ocEyjeHKFDngNsmw02npcsFFK7xXAbtoSFrN0=
MIME-Version: 1.0
Reply-To: dkirjanov@kernel.org
In-Reply-To: <20100708201224.GA2387@kroah.com>
References: <20100629085216.GA6391@hera.kernel.org>
	<20100708201224.GA2387@kroah.com>
Date: Fri, 9 Jul 2010 00:21:54 +0400
Message-ID: <AANLkTilhsDILQNZJXxs8o4XFmlueOLTvG-h_b67XOOJj@mail.gmail.com>
Subject: Re: [PATCH -staging] slicoss: kill functions prototypes and reorder 
	functions
From: Denis Kirjanov <kirjanov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Denis Kirjanov <dkirjanov@hera.kernel.org>, devel@driverdev.osuosl.org,
       gregkh@suse.de, davem@davemloft.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 12:12 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jun 29, 2010 at 08:52:16AM +0000, Denis Kirjanov wrote:
>> Reorder functions to kill their prototypes.
>>
>> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
>
> This doesn't apply to the latest linux-next tree, care to respin it, and
> the 2 other patches after this as well?

Sure.

> thanks,
>
> greg k-h
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>



-- 
Regards,
Denis
