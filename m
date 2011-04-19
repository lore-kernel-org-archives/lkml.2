Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1DSPYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:24:54 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43530 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1DSPYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:24:53 -0400
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
Subject: Re: [V9fs-developer] [PATCH] net/9p: Handle get_user_pages_fast return properly
Date: Tue, 19 Apr 2011 20:54:49 +0530
User-Agent: KMail/1.13.6 (Linux/2.6.35.11-83.fc14.i686.PAE; KDE/4.5.5; i686; ; )
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1302856173-10566-1-git-send-email-mohan@in.ibm.com> <4DA85BDC.5030407@linux.vnet.ibm.com>
In-Reply-To: <4DA85BDC.5030407@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104192054.49797.mohan@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 April 2011 8:23:16 pm Venkateswararao Jujjuri wrote:
> > 
> > -		if (err != -ERESTARTSYS)
> > +		if (err != -ERESTARTSYS&&  err != -EFAULT)
> 
> Please analyze other errors that could be returned by
> c->trans_mod->request()
> if they need any handling here.

Thanks JV, but we don't need to handle other errors as of now.

I will post a V2 patch with retaining printing error message.
----
M. Mohan Kumar
