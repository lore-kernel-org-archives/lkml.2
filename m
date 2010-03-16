Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713Ab0CPGRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:17:50 -0400
Received: from smtp120.mail.ukl.yahoo.com ([77.238.184.51]:47211 "HELO
	smtp120.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965206Ab0CPGRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:17:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=AegPuygl1f7OMMoNErDBl/M9raTlx8Xol4oSXYd8CKgySE0GUu1ELX31U3exfLLJlQlKrfbguJZox6/uyspXS4UsyVYMxN0zgRDRes7lXKqOJRbo8TYKXhXxYdPRa5GOmOfjk76+PFzKwMfMry2XSRh/mxo4iR4ljNwQEBGGsKw=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: zNckvGcVM1nbQjlRLj._SRULegJUV.qm1bkA1nuKK.CYh3HBvTHSrs7OPyIr6vWrGoDFU37J8K0kgmI.OtwQ1V30a7TCjgLWkUKbMcQ1Xk2tGd6oAq._jFrUvUKkDKEh34YY0BNwQD82BIFXSVzXHNzet6CPszTQwq6vpIVXOQtoP4enTlDp.PIxiioPfKC6Dg.MN6hyy1m7fmQV_O5PJIn3VQPt
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B9F228A.8030005@yahoo.es>
Date: Tue, 16 Mar 2010 07:17:46 +0100
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v4 04/11] swiotlb: support NOT_COHERENT_CACHE PowerPC
 platforms
References: <1268421166-4791-1-git-send-email-albert_herranz@yahoo.es>	<1268421166-4791-5-git-send-email-albert_herranz@yahoo.es>	<20100316105423B.fujita.tomonori@lab.ntt.co.jp> <20100316112444D.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100316112444D.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> If we want to make swiotlb generic (make on any architectures), we
> need to handle more cache issues here, I think. So it's better to have
> more generic ways instead of adding hooks to some archs.
> 

Ok. So what would be an acceptable way of handling this in a generic way?
Should we for example have 2 levels of DMA ops in the swiotlb case (swiotlb and "actual") and call the 2nd level ("actual") from the swiotlb code whenever we need to act on non-bounced buffers?
Any other ideas?

Thanks,
Albert

