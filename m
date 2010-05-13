Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0EMFET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 01:04:19 -0400
Received: from smtp138.mail.ukl.yahoo.com ([77.238.184.69]:35396 "HELO
	smtp138.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751467Ab0EMFES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 01:04:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=fIgIrKWeLN9/StsmMfCvdBfuZyGyVAVFWxhGcuOu6E33X0988HQD+Jqw1ItBA38H3B4aq2py7FMGzTXD+Zj8kOAq7IIdxjVmpcD2MWObFxPywIxSOGP4tnVmd929z4lm6AworSn2VfhTIncEwz05GsKYgdIt3Jr7Xgqfg9rEzts=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: aMe51.QVM1n_pDPX3GlEz30Hf8QuCxSzlUljlXHINAjWU4qViXFU6TSEglQDqTRSB4mh7K_txrWEvrrQShcD.MhPUPeQtZGeaNFYbfOLf55.NiOSYv4TafHaCN3LXgEVJBcFaACRRN5WjvtNmdxqZ5VD1zgPC2_6t69cjyFk.3nKFybv1K4qAkSsgOd2fW41X4WpVfGcn8CKltwt9ADoZVXoojjB2zEhrRpnzHDhpNC67B4bBEsGXM040ozxWkUCh15nficntU_n2NWeW4LKplywlRZToaB04A--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BEB884B.7030402@yahoo.es>
Date: Thu, 13 May 2010 07:04:11 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian.Campbell@eu.citrix.com, jeremy@goop.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions visible
 in the header file.
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-5-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-6-git-send-email-konrad.wilk@oracle.com> <4BE9A1C0.3090505@yahoo.es> <20100511184657.GA23464@phenom.dumpdata.com> <4BE9A989.5020808@yahoo.es> <20100511193918.GA4166@phenom.dumpdata.com>
In-Reply-To: <20100511193918.GA4166@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> So these two patches (one to replace the PATCH 1/6 and the other to
> replace this one), would work then:
> 
> I've put the whole tree at:
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.8.1
> 

The whole series work fine on the Wii 32-bit PowerPC platform (used to implement the MEM2 DMA facility needed by its EHCI controller).

Tested-by: Albert Herranz <albert_herranz@yahoo.es>

Thanks,
Albert

