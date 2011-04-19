Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1DSB33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:29:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41642 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab1DSB32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:29:28 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=wom5GMh1gUkA:10 a=n9MmX0RCC_8A:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=pGLkceISAAAA:8 a=0qwYxUaSe-xcaSBP4wcA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Mon, 18 Apr 2011 20:29:25 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: crocket <crockabiscuit@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
Message-ID: <20110419012925.GA5734@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
 <20110417180722.GA21112@hallyn.com>
 <BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
 <20110418082838.GA30088@hallyn.com>
 <BANLkTi=kxpFkQ86ZGd2_q+XFRm-nVWzw4g@mail.gmail.com>
 <20110418220232.GA15967@hallyn.com>
 <BANLkTikJqgwGixtgXKOY-2e=1sAQYUtbcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikJqgwGixtgXKOY-2e=1sAQYUtbcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting crocket (crockabiscuit@gmail.com):
> Is there an existing utility that sets SECBIT_NO_SETUID_FIXUP?
> Or is there a way to set it without writing a C wrapper program?

You can use capsh (with --secbits=), which ships with libcap2.

-serge
