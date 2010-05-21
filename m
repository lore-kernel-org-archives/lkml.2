Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0EUIoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:44:17 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:52087 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab0EUIoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wlNHHzTI6rxan2YAhQBoAOsHbh5ydj/ZzWeVcva2oreclY/F5/Zlgw9ko8+BVGcWO+
         r679TkeUjTGsLewdGsA2q+0WVcCg3hNgpWvfY6Z1yj2n+uAax3ROCnwpbGrAK2aHnx/9
         w7b9sJAyN1+X4lxC906/O9bJEhnvLankzPKFg=
MIME-Version: 1.0
In-Reply-To: <m2vdbb048f61004190326ve4220de6za13c94eed059ec2@mail.gmail.com>
References: <v2mdbb048f61004132326r8ac75382k1e42321ff0ed484a@mail.gmail.com>
	 <v2he9c3a7c21004141730vcc79dd58t5478c9d83af9816@mail.gmail.com>
	 <m2vdbb048f61004190326ve4220de6za13c94eed059ec2@mail.gmail.com>
Date: Fri, 21 May 2010 14:14:14 +0530
Message-ID: <AANLkTikpI9hK24jjk5hwdVtWUlwQyllAeGhLxjtW5TPH@mail.gmail.com>
Subject: Dmaengine query
From: rd bairva <rbairva@gmail.com>
To: Dan Williams <dan.j.williams@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

   My DMA controller supports device to device DMA transfers and we
need it in some of our drivers. Existing DMA engine framework doesn't
have support for device to device transfers.

Do you have any plans for device to device support in DMA engine?

Can you suggest me some other suggestion for doing this?


Regards
Ramdayal
