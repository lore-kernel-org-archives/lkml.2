Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1BDWSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:18:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56245 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1BDWSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:18:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YJtyJqQuS+CGurDx65xs3dTbJbzZFstmUD7Uw62JTM3EfDoU04nNWI2yVIs6qHN5wt
         fQHBHRLYILSBSnhN/Exocxd23nalONVFa4cNtLdB49jQ7xnto2JzPVjQoE1UKpkktSpv
         rBKNhPJHlhutMyku/QbAsV/tXn7bnNk42qGJg=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=4DerY5d+fchfZ3JwVVBq=PFb8jRLvvczzYvjw@mail.gmail.com>
References: <AANLkTi=4DerY5d+fchfZ3JwVVBq=PFb8jRLvvczzYvjw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Feb 2011 14:18:32 -0800
Message-ID: <AANLkTim7hUAcdfpS_4xNMQKKrpLq5D+KZrb0gw4JxfnA@mail.gmail.com>
Subject: Re: compat-wireless for 2.6.37-rc3
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 4, 2011 at 2:16 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>  A bit late in the RC series but I just had time now:
>
> http://wireless.kernel.org/en/users/Download/stable
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.38/
>
> Please test and report any issues.

Oh this is just the vanilla release, I'll work on sucking in extra
pending stable patches and if you can think of patches you want cherry
picked, etc, just send me patches.

  Luis
