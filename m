Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0LJXCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:02:24 -0500
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:26488 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754670Ab0LJXCW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:02:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=SEiAGpFXLLINKSJJXVCySzzrgpLWm7r4oaU1JfOj3eb2TDBHCDT95GMgBcZDToO2dEa+H6pqEFOe/Ehmvpa/xHKyCO2/tonbuLZC5HXVzzudJAXD5MnrLvzvcGxOl1HCbXqZL4X+lD0Z2kL3e4fyoAghJt3o+WjYrqdp1CvMKCM=;
Message-ID: <101815.7005.qm@web31804.mail.mud.yahoo.com>
X-YMail-OSG: uhKzIVsVM1n83TKTfkgk4qwVBLSa_t2AbjJUyFjP2PVRNBT
 lM_FwJNHxDUhf4Tb6bQf8xwVPsCWg4ucYMAhe2fZBlHnLG74767YqhpfPsqm
 otmsSl0o5nMltnjWcCaHa2_Eqm7G2Mb.CFN3mn_p9cOSyFr4Jx.m8lKC5Hrk
 pLlpSXshCrdxsi5GLF1_QF.HO8vm2bmWTDUtKFTIsHBiNMVFeYfQ3Xf8zzLu
 KrDkQvbbnQhlkTXiNF_ODDlwAp8H4dEiwX.lLONEKl_JofbBZeWPqvfDY2l4
 laLB_sQXshY0U6cq26Pxz_3SSR1v0BkC11TeSrRjJ2QjqSAEpzkD.IaPfuTa
 yr4O8ILHcHWtSLN8JmGVpc3MKAjGfIHAYdj_8PqaY9YcU7o5Kyp5gVprVgnN
 xzfCeso8Zi64-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Fri, 10 Dec 2010 15:02:18 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH 2/4] [USB] UASP: Add MaxNumStreams module parameter
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
In-Reply-To: <20101209205820.GA6014@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 12/9/10, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> In the future, please Cc me on any patches that involve
> xHCI, or bulk
> streams in general.  I'm not an enemy; I frankly don't
> care which UAS
> driver gets in the kernel, I just want one good, well
> documented driver,
> and for the xHCI driver to be as good as possible.

Then do the noble thing and retract the still-born uas.c where you're listed as a co-author.

    Luben

