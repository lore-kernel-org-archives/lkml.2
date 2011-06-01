Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1FANey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:34:54 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50970 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1FANew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uOvG965X5cjRQoB+NZVhzEw1W3KoC+mEL0DlHBPyIjSd1x6i0rSOhWN/KiP2QCtyJr
         36B4y+VbyK/Cn5bBPZe/NFY3xxFa8bbt4TdEZyAGwRBC9q0++LzVyz5Bz63XAjq6pPdl
         3liNQaU1oELA7sum3yH1ZgPclqs9mA+MCaGQ8=
MIME-Version: 1.0
In-Reply-To: <20110601150915.4af71a0a@endymion.delvare>
References: <4DE3E9E7.8020008@zytor.com>
	<20110601150915.4af71a0a@endymion.delvare>
Date: Wed, 1 Jun 2011 16:34:51 +0300
Message-ID: <BANLkTimjcXJoZtXm-BgROZSdVSKo+cR-6A@mail.gmail.com>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 4:09 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Do you mean files in testing/incr such as patch-2.6.39-rc6-rc7.bz2?
> Yes, I am still using these. That being said:
> * I guess I could extract these myself from git with a simple git
>  diff command?

git diff v2.6.39-rc6..v2.6.39-rc7
