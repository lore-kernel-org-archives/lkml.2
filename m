Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0JYPSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:18:50 -0400
Received: from web37606.mail.mud.yahoo.com ([209.191.87.89]:36948 "HELO
	web37606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754278Ab0JYPSt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:18:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=nczCpfNcGrvSChFUF4Khl49feszJ3BCabVuXmFh92eEbE+JlRQDs6aMeMSSd2VSrS9ygDHH6tkm/6LasQqLqOVupSFYL/cBQrv5bMSh164lVuKWd+K23CePJ+q8r1gLJIe7swTMTuXBPjqOJdjYY3ZQhxt1cF3eppDdSsxdgB9o=;
Message-ID: <479817.96049.qm@web37606.mail.mud.yahoo.com>
X-YMail-OSG: 3P_JyH4VM1nm.NuLcDWjfifCA6coPjh5svHsl2Q4Q8cwEuS
 rx4.t5Wz1ch4eJG0JRKIyzICA6tUsD2UR7V1WOn2Pg71oh74odQ6s2kmVNeU
 49n9h4j5mFHRNfh2Z9zepT7hpgnRNyDb3mJVO.AGdlij8IEi0ZY5Ta1Lx9eJ
 HhL8yqAZDV4jXdyYICfKysyT6NsKFQT9NtkyqrMQrCgbE98eS9XHONFRKS30
 B3Ddy62gAk3TawUH98LoDzlLKuQWBPqA2hSQjCbPqzozOC6NmCY1jYvLKWHy
 FR2W9uE1BuI_cE1gGFvEmGsFX0sAkH9oKzduTQAt7Ncr9_ypsVMIZq6L1vwa
 BAHux6COaDzhRMTvSw1h1_YJGmXBEfwQIJk.fSlSYM4mZZSjYnQ--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:18:48 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 08/29] memstick: mspro: add comments to few functions
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-9-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 08/29] memstick: mspro: add comments to few functions
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> a comment before function is not only
> a good way
> to give some information to the reader, but
> it serves as a good anchor point for diff so that
> it doesn't produce a diff between different
> functions (sigh...)
> 

Comments of new functions belong to the patch which introduces these new
functions. And those functions (as I already said) belong to the patch
which introduces new functionality, using these functions, desirably,
one function at a time.





      
