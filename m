Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab2BMQb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:31:26 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:47831 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757185Ab2BMQbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:31:25 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oQeLrgYVM1kaCTA6eXtxxZb98dCJpg7pM7oGLdTkqZ61TGm
 _hM5.054zVT4Kp.Kw5WFcMPMIB_BMiTNyoTvbDBykyycCb.YmIfRE4BCfrdT
 MDvs0gqM5.s.BWjOvxvOzmpio6RJBxG1UEFNTGXhpB45YSqHb3PqYcXmHrKT
 .pTbx6F1R4neA2Jlw4lHTb9HkdwjWzEs0KHwYN7nFGQb.YGiP4GA2zo5OZpZ
 LIyQ1szb26IVvq8M6lIoACwy5wgR8JFIAAkuIBmGhwL9GHHf2kPWHTLgwL88
 CAc9rY9AvA6hGHInkmkePuqezJTsgAD1B7cyiWZDKe5G.Y4V8cYDu8oNIcPR
 NOTUpRngbF8JbsO_WEw.4yiIZ9D8wNtN4qFfMedDo9314dOm6Ok_AVUTr4Dt
 s
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 13 Feb 2012 10:01:42 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Xi Wang <xi.wang@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jesper Juhl <jj@chaosbits.net>,
        Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
In-Reply-To: <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com>
Message-ID: <alpine.DEB.2.00.1202130958470.23562@router.home>
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org> <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk>
 <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net> <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well I think the best is just not do any of this. One can already do
k[zm]alloc(x * sizeof(struct whatever)). Do x*x for 2 dimensions etc etc.
No need to change the API.

If you add these variants then please think
about the necessity to add other variants (like the kmalloc_node() NUMA
call) etc in the future.




