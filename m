Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0GBLyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:54:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50896 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0GBLyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:x-originating-ip
         :in-reply-to:references:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=V5G91dmt/YGQI+9zB7U2gd8xlBLxuOUtYEur6EfFL8EkRGVlPwh/9uBpukQCRqoVat
         hOdMYjRbQwcIGTmXVx7/KRCmo5vw93uk1p6KFzOsvgF1fDngMpnjyAXbQW7xnLevznOl
         ZdJD55aPjfT03Z42myirY8iauL7Dg3Qcg+thI=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:content-type:content-transfer-encoding;
        b=WxSzIjzhTlRzqcCsyuYaEL4pEsxxYRP4S20U61RULTHoTb7SXeDxaar4erEiZfowKJ
         oS6lMTdWm6ezegklZ57wFvrzj3O32qPbzgFQso2B95wbo1kx5ZQ9o+sZQcaLDRCiE/uW
         VnPz85aM0XT8voyXjG3WwuzLaOg1AtdW7zQWg=
MIME-Version: 1.0
X-Originating-IP: [193.174.122.53]
In-Reply-To: <AANLkTilN60yM1WFKUOep0KsvXedtdyfEuCVRTeg61cEH@mail.gmail.com>
References: <AANLkTilN60yM1WFKUOep0KsvXedtdyfEuCVRTeg61cEH@mail.gmail.com>
Date: Fri, 2 Jul 2010 13:54:07 +0200
Message-ID: <AANLkTilqdiyhixzrDO1v3T02gOQPnZoGqyGuimxl-otT@mail.gmail.com>
Subject: Re: Fan control with kernel module "asus-laptop"
From: orschiro@googlemail.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody?

Who is working on this module and updating it?

Should I directly contact him?

Regards

2010/7/1 <orschiro@gmail.com>
>
> Hello guys,
>
> I'm using a Lenovo Thinkpad SL500 in combination with the asus-laptop kernel module. Everything is working quite fine, the last commit brought excellent support for my laptop, except the support for cpu fan-speed control. I remember to read somewhere that this feature was planned to be included but it still isn't.
>
> I'm aware that there is an inofficial module called lenovo-sl-laptop that does exactly this but I prefer to use the official one.
>
> Does anyone of you know when I can count with this feature?
>
> Best regards
>
> Robert
