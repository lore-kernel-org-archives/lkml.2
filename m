Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2LEXAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:00:15 -0500
Received: from nm2.bullet.mail.bf1.yahoo.com ([98.139.212.161]:22940 "EHLO
	nm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab2LEXAO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:00:14 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 162377.68558.bm@omp1070.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=DWKwpb87nalhc1/Fhk+426C/wYXLP2daL4hscrNg0jg3VEbWDwM4HSDe/cnjDL91P6YOYVOCFuaHWldIIyXURqArHxE18ZCUC3W9orlqO/cOZN7PXHGp6OAYtnObNhInspZWhqHuoxx9mfwQYUl7FcSgRFA4QN2Lo0exKcPs2fY=;
X-YMail-OSG: 7Xh52i8VM1nTqWLxYWq7NUGWQsEWzoIssgS.ql7.xd8z75k
 uzU0gJ7zi.zLSBNUDjXZU7XgWj3ZkJDaK.4VHKqhMW7bxvF4paRcz4Fb79nV
 mXuCHTaAg1oAfVzqWyMAw1_bzhIgURwzChEx6GvlyNDxvXNdkhAMQsLGeL7q
 D1W3K0hWqstccMZ9eDRwIjx4DISazB8NgHbGnf625R0i.ofBYaGIBAsNH2cs
 gg_VmH2QitXSegu0XvI_mQ4Um1V_F.hBWqXN5ubdsdUlvi03xtYyAcUwvsv9
 jnyLlQBAUHmJJDE.hLiB8uwfUY7W5slV50auwqrRygiDHA77dFeVQG4SCteP
 6eBaX6LSwxIevoNAwFVXtYGI.d.JodQruvZXC5HozkfnOMByYX00qIMWhUL3
 bCgDo.N.z_vENFKJhNE5IRORyaJw8l2zrqdb6ovA_Fk4vSQD5B209sLLEm.4
 Hdb4Xk1nw_7mgDbnhVVZxGmI5zNnseSFVq6eogZ7Nf66tuIiCJO3z1rASiJ8
 pULz1_VRiF.SDEuUJd_2lQv4-
X-Rocket-MIMEInfo: 001.001,PiBUaGlzIG9ubHkgbWFrZXMgc2Vuc2UgaWYgeW91IGNhbiBzaG93IGEgbm90aWNlYWJsZSBwZXJmb3JtYW5jZQoKPiBpbXByb3ZlbWVudCB1c2luZyBvbmUgb2YgdGhlIHRob3NlIC1tYXJjaCBvcHRpb25zIHdpdGggYXQgbGVhc3Qgb25lCj4gYmVuY2htYXJrIGZyb20gdGhvc2Ugd2hpY2ggd2UgaGF2ZSBub3cgaW4gdGhlIGtlcm5lbC4KClRoYW5rIHlvdSBmb3IgdGhlIGZlZWRiYWNrLCBCb3Jpcy4gwqBDYW4geW91IHBvaW50IG1lIHRvIHRoZSBidWlsdCBpbiBiZW5jaG1hcmtzIHRvIHdoaWNoIHlvdSByZWYBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.128.478
References: <1354745355.79857.YahooMailNeo@web140001.mail.bf1.yahoo.com> <20121205222738.GB6239@liondog.tnic>
Message-ID: <1354748412.17691.YahooMailNeo@web140005.mail.bf1.yahoo.com>
Date: Wed, 5 Dec 2012 15:00:12 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [PATCH] Additional compiler optimization options
To: Borislav Petkov <bp@alien8.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20121205222738.GB6239@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This only makes sense if you can show a noticeable performance

> improvement using one of the those -march options with at least one
> benchmark from those which we have now in the kernel.

Thank you for the feedback, Boris.  Can you point me to the built in benchmarks to which you referred?  I am interested in probing this further.
