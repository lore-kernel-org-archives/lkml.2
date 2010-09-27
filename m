Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab0I0VEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:04:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58159 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab0I0VEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KWj9fVJb3ujkedrEgnJr/xaEJk26D3rScxRBYaElBdU47WQWJhXMjIsnoo84Qx905i
         QJRXbS6Trd//phbp8GnTinSxYwuAGJ/QC3mnY/dH6mKvyCa+u3WkPpBLrj74uuutkUbc
         /Z392B9z4olnD0pb7T4oHVEYLMlTGXM5yr26Y=
MIME-Version: 1.0
In-Reply-To: <20100924064446.GA22588@foursquare.net>
References: <20100924041410.GA18040@foursquare.net>
	<20100924060557.GA21238@foursquare.net>
	<20100924064446.GA22588@foursquare.net>
Date: Mon, 27 Sep 2010 23:04:07 +0200
Message-ID: <AANLkTinQ20uSgFP5KV17B0J0v8Y0zAg=AgAd_kf+4Bh0@mail.gmail.com>
Subject: Re: ext3 filesystem corruption in user mode linux
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Chris Frey <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 8:44 AM, Chris Frey <cdfrey@foursquare.net> wrote:
> On Fri, Sep 24, 2010 at 02:05:57AM -0400, Chris Frey wrote:
>> So far I have been unable to make 2.6.32.21 corrupt its filesystem
>> when running as the UML kernel (Host 2.6.35.4, UML 2.6.32.21)
>
> Spoke too soon... 2.6.32.21 has errors too, if pushed hard enough.
>

can you do a git bisect?

-- 
Cheers,
//richard
