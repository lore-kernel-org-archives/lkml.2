Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2A3SPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:15:37 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:37964 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752055Ab2A3SPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:15:36 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iqgTEjwVM1mE1IuM8Wv0lrr5JMh6WEjLDIIjs33lPqj8XKC
 Uvr2d9A9ppXKV3PBs3cXfE7Knjgw7ncp1Pfu91GOJa6.QlhSDOiNfaoPnvgx
 RQTovk75Q3ATuAQZwOnGPo3uM1lQELi3R4ldsfISXNCMgntKr3znZOFG2F2h
 1N3C2jWUTgC8xQHFRUculbfvkJOuvu2bA.TvWuXs6dWnEaeKbFjF3Po9cm3z
 3.ymr3HKMg3Oe5sAZcmtRR3N4BdECGDcHpj.2DlpDOCXYgHuGpAFl.s5pkU0
 dUPQr2h4YPyA7ewNmTMJs9yL3icFwJaJiSHTQZZ1jP3I8JMr8jQIq_uy5dhf
 KHw32VxYvmSgaCVTN.m5VGZHTdIL644ZUnvEtaYcmrxlVeYr.cf3V8bGFSaW
 L.AcDyY3UfcK3hrBORK52P7f9DXVgEWJMWub6cfKd
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jan 2012 12:15:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
In-Reply-To: <20120130181313.GI3355@google.com>
Message-ID: <alpine.DEB.2.00.1201301215120.28693@router.home>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org> <20120130171558.GB3355@google.com> <alpine.DEB.2.00.1201301121330.28693@router.home> <20120130174256.GF3355@google.com> <alpine.DEB.2.00.1201301145570.28693@router.home>
 <20120130175434.GG3355@google.com> <alpine.DEB.2.00.1201301156530.28693@router.home> <20120130180224.GH3355@google.com> <20120130181313.GI3355@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Tejun Heo wrote:

> Anyways, yeah, it seems we should improve this part too.

I agree.

