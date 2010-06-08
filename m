Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0FHNh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:37:27 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:44169 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753963Ab0FHNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:37:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 149994.55154.bm@omp205.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=L4ID5MnYr+QapqeedWc2Y+vSreqlxRa9cSmNC/WGZ9BgdmqFBNiyztT/pM9lwVqU4vuvngCukBI0iWWVPxJUAK5yv+KaGEdDr/pWerrYhuB8HL90tC4L7AmoXSHVi0Xdedv7gB2dprE1kwbKSelceNCT6H9rXnHRR83Xb3TwBeI=;
Message-ID: <778712.18431.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: pdezZ88VM1nGIucNmxCTA2EydoMYANIAYh0Hokco9YUfaHH
 w.F75nGNsU5PEQhuMjlW2GnO_vjHtwT1ZRozTtoqL4fOgzwtmZYR2FXM73PE
 QNpqfpdOJ_tCFKXIoiso4CQhNJMCvgU1DbGN6koTRxPYOFk.YcFSgI_dt1YZ
 nJVtp2b6aJoNHlJy.6fWyudUAk7VdxVZhIPvI_m.ZnXMRK2G0HdL2K3GZZO2
 GMCLrMWDeK5GHQoTpJ6iUr88bV95mRVqNHlGrjUKQcGwgj5ch37.3mm.Dj01
 RNFI.A7EV1x8LPaINBVdhedmo1mv6351vhAOv2DTkJmSVt780YWX79g--
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Tue, 8 Jun 2010 06:37:24 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv4 10/13] USB: gadget: g_multi: more configurable
To: linux-usb@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <b2b534da1e741bd0438e5e13df65aa7e2be72a7c.1275906835.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 6/7/10, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:

> Date: Monday, June 7, 2010, 5:39 AM
> Added Kconfig options for each
> function used by g_multi so that
> one can customize the gadget to a greater extend.

For what it's worth ... I still NAK all
these complications to what's been intended
to be a simple driver.

If you want to create some complex monstrosity,
that should have been a different driver.

Unfortunately I see that some such patches
have merged despite my previous NAK.  Sigh.

