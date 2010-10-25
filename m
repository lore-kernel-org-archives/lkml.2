Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0JYPHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:07:22 -0400
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:21302 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752107Ab0JYPHV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:07:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=z6Jn4fWtIYGJ4dY7U0vvCfTbWc+T3Y6fiRs+08TYWQnDagrF1RHjU8cTwBz4Edu6qbJ9EdPJMVsSb5gpN3SxBJmW5+nJTDZtJVGTFetoev4hw/PKQAXYtaa+PJMqHU6z/xi8xKXeRc+jzDKDIQTW01MJVc6xFtCq/KHmNAnm8IE=;
Message-ID: <707256.89727.qm@web37601.mail.mud.yahoo.com>
X-YMail-OSG: 7O4UIrkVM1kvhnWT12CapWZvCSt6EsrRBE.NYWbrTv8qfVV
 PxT7gfDEl4HK0GPw1WCAoLoySpAawzO5zX7eVBQXYTaqxh3z6xJ3rEoE64yy
 Y5WqV1O3R8.RHJiwefaaIu1inqXLxt92gXQevEhmHcq_fFDzOo.JVz0POCCU
 pOLmP4vm8ESESjW.pAHKQguWXoKXlT2fgUK4EWjgScbad8hfiJl4kfuB6HDw
 RIJBBVKYCyL_sGHhdx78aZQ2HRbq22TPQ.vX2FB27cbLeYajtY_pgWfIAlC.
 aU.5BpsP340q5q3EagYWEnHTzpx.z3uHdJk5ACimxa_aWNTZ1.M.bq9ob9Qz
 6M83Tdbo8zaM55eulJiWG.O63DwmBDTjJgbPDuhAWNfcDSLdg
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:07:20 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 05/29] memstick: mspro_block: move declarations to header and refactor things a bit
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-6-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 05/29] memstick: mspro_block: move declarations to header and refactor things a bit
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> This makes it much easier to lookup
> things and reduces size of mspro_block.c

Subjective and irrelevant.
My editor makes it easier to look up things when they are in the same file,
and this declarations are not expected to be used by any other compilation
unit. Belongs to the cosmetic category which should be discussed later.

> Also add debbuging macros so that it becames possible to
> control
> debbuging via module param.
> 

Should be done through a common kernel infrastructure, namely DYNAMIC_DEBUG
feature (pr_debug and friends).



      
