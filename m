Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab0DVEFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 00:05:44 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:59022 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0DVEFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 00:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n2WhlviaCtEL4jBSQMDGA+LKCs8RXhKT4udSSu8rNZaf8vtUL2l8u74fVz/svTrmsv
         cxXTYeRKHsnqRAa6LdMMpmlhXbK2cZ3ANzUYDn6bf15mS2dsxwnKsVRdvaLJ7n29cnm1
         +NPBcYnZosH174A0of/UrHh7ltsx+iZp1tLe0=
MIME-Version: 1.0
In-Reply-To: <m2vdbb048f61004190326ve4220de6za13c94eed059ec2@mail.gmail.com>
References: <v2mdbb048f61004132326r8ac75382k1e42321ff0ed484a@mail.gmail.com>
	 <v2he9c3a7c21004141730vcc79dd58t5478c9d83af9816@mail.gmail.com>
	 <m2vdbb048f61004190326ve4220de6za13c94eed059ec2@mail.gmail.com>
Date: Thu, 22 Apr 2010 09:35:42 +0530
Message-ID: <v2ydbb048f61004212105n80341b00p89b80565b94459e5@mail.gmail.com>
Subject: Dmaengine query
From: rd bairva <rbairva@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My DMA controller supports device to device DMA transfers and we
need it in some of our drivers. Existing DMA engine framework doesn't
have support for device to device transfers.

Do you have any plans for device to device support in DMA engine?

Can you suggest me some other suggestion for doing this?


Regards
Ramdayal
