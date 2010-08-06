Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935451Ab0HFIBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:01:32 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:25255 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933008Ab0HFIB2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:01:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=DiPaqq+PRPXQjVGb0ELbt1gRj3IllS7OXTEaMKlx3ZtKqBP49wz3j9OC25tv0UuFCTI5oMyOfdV2WLkrP+P6cytcByvyKIV0WfD0iyl+I6zObBTxHG9d9cbcjLTURSpC3n+fOgiddoE6alwUpbqvtXRqXQe2SQS2CVLNzxaB3GU=;
Message-ID: <939673.34027.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: u1lnrhEVM1kcgf9GJL1z13Fa1fiXfg2uVaPG0Vt49qjWTnx
 6t9J6troDpab_H8fLfEiVMLaQLzecQrktkMs.nQOSa_48Uw72TfDCA.e24a_
 OsVXoeVlLhLUtYvf.0CqpLUb8J1u7I6p_WFq3gUDrIxGVxvmvQpuuAh9PBVZ
 n0l5kpWOr7Qaa.SD3iRGr3WQpD4TmNL8e0Q7NPNB30oCT.0rB9X2a7zHVh2w
 kqea3UQgr_ebY3RoZIMijCnC2T7hUeWx4CnuEhpS40Nk_JGkAUWLmIWml.z0
 BYH1On7Q_cwtioHzp64SEzVVO9q63kOK7754r7_w-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Fri, 6 Aug 2010 01:01:25 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281011437.9324.14.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > > 
> > > Small question, can I use Pro-HG stick in my
> reader that is
> > > designed for
> > > Standard/PRO only? Does your subsystem support
> it?
> > 
> > It should work. It works for me on TI, which has no 8b
> mode either.
> In that case, is there an upper limit on sector size?
> 

Good code has no artificially induced limits. Less than machine page.



      
