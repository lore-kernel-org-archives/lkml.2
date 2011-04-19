Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1DSDF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:05:58 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:53640 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1DSDFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YQ1IF45rYQNhsxtVcwqVYHZ7UUL8sW3trF4HAqmQ/RHLnBkfIwhEXiRZuoNZBAvZPQ
         o8a9vDEmXOBkzMDHVp/Rm5ClR6V+lPBmGBaI4ClUe2CjJ+MgbiTMgtgFEC3n+fwGLgVH
         1Z8uFt9sYdxtbWeNw7TGFPcCCEcs0zYL7Rf5s=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com>
References: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com>
Date: Tue, 19 Apr 2011 11:05:54 +0800
X-Google-Sender-Auth: Wku5FaiDBQH7ZaG5tfpI-P4QLNU
Message-ID: <BANLkTingpBu6Xnpd8QdGX7LfUb3UDKj59w@mail.gmail.com>
Subject: Re: [BUG] bluetooth doesn't work from 2.6.39-rc1+ to 2.6.39-rc3+
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/11, Hui Zhu <teawater@gmail.com> wrote:
> Cannot connect to any outside devices through bluetooth.
>
> And I think this is not a bug of low level driver.  Because both my
> laptop and a usb bluetooth card cannot work.
>
> Thanks,
> Hui
Maybe this patch can fix ?
http://userweb.kernel.org/~akpm/mmotm/broken-out/bluetooth-fix-build-warnings-on-defconfigs.patch
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
