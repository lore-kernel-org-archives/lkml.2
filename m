Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1KOQF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 11:05:28 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:24354 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756102Ab1KOQF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 11:05:27 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3fLueY0VM1lp8iW.b7DeP0riDxFb.izGpWxHu_8It_H6mcA
 6XdTKDj6_0mC525v97JKEWyVrKmNCBaX2TT4puOlpavRG2EGVg51z6EKfpyI
 9WDnwHQ3a3wkJJ3mNZ3ldzK83jw_c_2fE_Q8YBVNehxwRmOX06lNftnS1JpO
 BqA3lP1LPTE6_bx2WZtqp28T7clPGAWTjwZBL8sJ3z2_5W2PEvzTGTvIyMra
 de7FygiFKtobRFxtCSVu4NxKvFCYoP9Ab.ZipuYbZuyKlcdYMy9yB_jib7tv
 c3SeCMeSzIvQMThldzentSLQZMCBE0RsgcIPfQa87uPzDXBRdnCml4ZB1cTX
 ba_BHiHyfBUbz4KFuInOjEcS.MJOZeMj07fnJk3w3PahpYFHcDVrdq13rDYB
 fiVn7U2H4rIDYThergxhGFw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 15 Nov 2011 10:05:25 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jan Kara <jack@suse.cz>
cc: Andrew Watts <akwatts@ymail.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [OOPS]: Kernel 3.1 (ext3?)
In-Reply-To: <20111114195352.GB17328@quack.suse.cz>
Message-ID: <alpine.DEB.2.00.1111151004050.22502@router.home>
References: <20111110132929.GA11417@zeus> <20111114195352.GB17328@quack.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011, Jan Kara wrote:

> On Thu 10-11-11 08:29:37, Andrew Watts wrote:
> > I had the following kernel panic today on 3.1 (machine was compiling code
> > unattended). It would appear to be a bug/regression introduced sometime
> > between 2.6.39.4 and 3.1.
>   Hmm, the report is missing a line (top one) saying why the kernel
> actually crashed. Can you add that?
>
>   Also it seems you are using SLUB allocator, right? This seems like a
> problem there so adding some CCs.

Likely some data corruption. Enable slub debugging by passing

slub_debug

on the kernel commandline please to get some information as to where and
when this happens.

