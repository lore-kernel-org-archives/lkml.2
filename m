Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1ANV2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:28:13 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:42227 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752378Ab1ANV2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:28:10 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: gbGpsn8VM1mx60L5cVZzhVIwzk2UpCR3yTSFYMCTG7IY8aj
 H2KYVcQjbqqrVJTCNM3OlTbho2HFyIcezZCdjUneVWzxCVS7N7yXijO_nVXN
 _jw6hoxlfMyjoJ__S6vQVVkwl5OeWsOAyHcbFv0QUFhGB8MyTKxUK2e.f35b
 p6FMfpg_6aDJJ77SE6mIDus4klFQFVPyG31FENMd1hvCzUSBnVzQlFSAHf5g
 i0t01t2dNsUEKW8ob1YWoJwPR5De3GFjWPHFQhPKAUar46t3vWnD_uyHr4Bw
 vIrcc0aomGmH7PddW_vommj2DaL1_uVF6h33w7O_AdK49WwhTyZ8-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 14 Jan 2011 15:28:04 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] x86: set percpu cpu0 lpj to default
In-Reply-To: <4D30BE98.7060809@kernel.org>
Message-ID: <alpine.DEB.2.00.1101141527400.10415@router.home>
References: <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com> <20110111135655.GA6901@kroah.com> <4D2CFEAD.6070206@kernel.org> <1294799565.9586.13.camel@pasglop> <4D2F7AE9.2000809@kernel.org> <20110113224450.GA14918@kroah.com>
 <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6> <4D2F84FC.7000804@kernel.org> <20110113234852.GB17904@kroah.com> <4D2F9948.8000804@kernel.org> <20110114004428.GA26847@kroah.com> <4D2FA305.2030808@kernel.org> <alpine.DEB.2.00.1101140846560.2423@router.home>
 <4D30BE98.7060809@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think Tejun needs to look at this. There may be a better spot for this.


