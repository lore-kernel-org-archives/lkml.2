Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1DRI2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:28:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1DRI2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:28:40 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=wom5GMh1gUkA:10 a=n9MmX0RCC_8A:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=pGLkceISAAAA:8 a=kwWpyMbcOuWpE7CL5XYA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Mon, 18 Apr 2011 03:28:38 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: crocket <crockabiscuit@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
Message-ID: <20110418082838.GA30088@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
 <20110417180722.GA21112@hallyn.com>
 <BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting crocket (crockabiscuit@gmail.com):
> I don't like the fact that an application should be linux-specific to
> keep capabilities after setuid.
> If users added capabilities to a file, they would know what they were
> doing, and they would want applications to keep capabilities even
> after setuid.

Alternatively, you could call the program using a wrapper which first
sets the SECBIT_NO_SETUID_FIXUP securebit, after which setuid would
not trigger any capability changes.

-serge
