Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1BOQkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:40:47 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:38376 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754174Ab1BOQko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:40:44 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: viSabBgVM1m274OyoD7cJH39Wu86eU56KXWgcYF.2jORKM2
 q5_v5Ec2cXSX_YGSztQQXwjcSldLKx2T6z4P7JrFF8DafULkBs6hXMYyM6nR
 MuTSbc.rA0kYwr7RIHSuXyPCXSlgklxkSHvCiRTACy7f8qODQTVUOyLq9XOu
 D4duD00zfgQZsXlDyzHn9seUUhaX4DZ6hnj6ZYWXedXn6mJnR96AFMF_pmvm
 BAqO0S0zZQQxHIDQhx.z05MCFSsmOr7YJ4AgphWm9YRbVozDR71qSIdDOs0I
 _2l.2qvghEgIUE4L1mleW29zz6zs6B.W8dMhHabmnHnkF4ao-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 15 Feb 2011 10:40:38 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
        casteyde.christian@free.fr, Changli Gao <xiaosuo@gmail.com>,
        Vegard Nossum <vegardno@ifi.uio.no>,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [Bugme-new] [Bug 27212] New: Warning kmemcheck: Caught 64-bit
 read from uninitialized memory in netlink_broadcast_filtered
In-Reply-To: <AANLkTinKTdeO5mnE38n==aZMz5P1XKKM+kykhoBu0=9k@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1102151034400.10511@router.home>
References: <bug-27212-10286@https.bugzilla.kernel.org/> <20110120122549.85863a84.akpm@linux-foundation.org> <1295556085.2613.22.camel@edumazet-laptop> <4D393A99.9060104@kernel.org> <1297704922.2996.60.camel@edumazet-laptop>
 <AANLkTinKTdeO5mnE38n==aZMz5P1XKKM+kykhoBu0=9k@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Pekka Enberg wrote:

> Looks good to me. Christoph, David, any objections to the patch?

My eyes hurt. Is there some way you could use tabs or spaces instead of
these weird symbols?

If the kmemcheck people are fine with checking data beyond the last byte
of the object then its fine with me.

Acked-by: Christoph Lameter <cl@linux.com>

