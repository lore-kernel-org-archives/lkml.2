Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0IGB7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:59:10 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:24263 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755502Ab0IGB7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:59:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: SM9MnNcVM1kxzGSXZqNEe5MSkM9IpOIGqOIIUx8NHOZ8JwZ
 cYtkGG.ltIJtfivKYtR6Mr5Q6e8.CM1WfG4pA6MDXyite9Id.AuLVhKSBDod
 jan07qF92cyPk6Gt3q0IW4Q06y_aWN.NdQCtFpYW89vIkuEN41qt_i2M.K_D
 Y3.WI57ocddRF_RPqWkK08GAT4D2.kB0fH7O3vxLEZoY.O097KVzWHobL21i
 _C9y0wCuFICVPURWUVQRhZVZZbZhj
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 6 Sep 2010 20:59:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 13/14] mm: mempolicy: Check return code of check_range
In-Reply-To: <20100906093610.C8B5.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009062058270.1485@router.home>
References: <1283711588-7628-1-git-send-email-segooon@gmail.com> <20100906093610.C8B5.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010, KOSAKI Motohiro wrote:

> I think both case is not happen in real. Am I overlooking anything?

Its good to check the return code regardless. There is a lot of tinkering
going on with that code.

